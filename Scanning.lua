do
    -- =========================================================
    -- BLOK A: STATE + CONFIG
    -- =========================================================
    _G.vanz = _G.vanz or {}
    local V = _G.vanz

    if V.installed then
        if V.ScreenGui then V.ScreenGui.Enabled = true end
        if V.Main then V.Main.Visible = true end
        if V.Logo then V.Logo.Visible = false end
        print("[VANZ] GUI di-restore")
        return
    end

    V.installed = true
    V.destroyed = false

    V.enabled = false
    V.sessionOn = false
    V.sessionState = "none"
    V.sessionStartedAt = 0
    V.sessionStoppedAt = 0

    V.liveStats = {}
    V._rawNC = {}
    V.captured = {}
    V.counter = 0

    V.staticState = "none"
    V.staticScripts = {}
    V.staticFindings = {}
    V.staticError = nil

    V.crossState = "none"
    V.crossFindings = {}
    V.crossStartedAt = 0
    V.crossDoneAt = 0

    V.staticProgress = { total = 0, done = 0, current = "" }

    V.steps = {
        ["1.0"] = { label = "DUMP SCRIPT SAMPLES", state = "belum", note = "debug" },
        ["1.1"] = { label = "RUN STATIC SCAN",     state = "belum", note = "" },
        ["1.2"] = { label = "COPY STATIC REPORT",  state = "belum", note = "opsional" },
        ["1.3"] = { label = "CLEAR STATIC DATA",   state = "belum", note = "opsional" },
        ["2.1"] = { label = "START SESSION",       state = "belum", note = "" },
        ["2.2"] = { label = "STOP SESSION",        state = "belum", note = "" },
        ["3.1"] = { label = "RUN CROSS-REF",       state = "belum", note = "" },
        ["3.2"] = { label = "COPY CROSS REPORT",   state = "belum", note = "opsional" },
        ["3.3"] = { label = "CLOSE",               state = "belum", note = "" },
    }

    local function setStep(id, state, note)
        if V.steps[id] then
            V.steps[id].state = state
            if note then V.steps[id].note = note end
        end
    end
    V.setStep = setStep

    V.cfg = {
        maxScriptSize = 500000,
        maxASTDepth = 30,
        ruleSeverities = {
            R001 = "CRITICAL", R002 = "HIGH", R003 = "HIGH", R004 = "MEDIUM",
            R005 = "MEDIUM", R006 = "HIGH", R007 = "MEDIUM", R008 = "HIGH",
            R009 = "MEDIUM", R010 = "HIGH", R011 = "LOW", R012 = "MEDIUM",
        }
    }

    -- =========================================================
    -- SERVICES
    -- =========================================================
    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Viewport = Camera and Camera.ViewportSize or Vector2.new(360, 640)
    local W = math.min(360, Viewport.X - 40)

    if CoreGui:FindFirstChild("VanzScanner") then
        CoreGui.VanzScanner:Destroy()
    end

    -- =========================================================
    -- BLOK B: LUAU TOKENIZER
    -- =========================================================
    local KEYWORDS = {
        ["and"]=true, ["break"]=true, ["do"]=true, ["else"]=true,
        ["elseif"]=true, ["end"]=true, ["false"]=true, ["for"]=true,
        ["function"]=true, ["if"]=true, ["in"]=true, ["local"]=true,
        ["nil"]=true, ["not"]=true, ["or"]=true, ["repeat"]=true,
        ["return"]=true, ["then"]=true, ["true"]=true, ["until"]=true,
        ["while"]=true, ["continue"]=true,
    }
    local function isIdentStart(c) return c:match("[%a_]") ~= nil end
    local function isIdentChar(c) return c:match("[%w_]") ~= nil end
    local function isDigit(c) return c:match("%d") ~= nil end
    local function isSpace(c) return c == " " or c == "\t" or c == "\r" or c == "\n" end

    local function tokenize(src)
        local tokens = {}
        local i, n, line = 1, #src, 1
        local function push(t, v, l) table.insert(tokens, { type = t, value = v, line = l or line }) end

        while i <= n do
            local c = src:sub(i, i)
            if isSpace(c) then
                if c == "\n" then line = line + 1 end
                i = i + 1
            elseif c == "-" and src:sub(i+1, i+1) == "-" then
                local lb = src:match("^%-%-%[=*%[", i)
                if lb then
                    local eqCount = #lb - 4
                    local close = "]" .. string.rep("=", eqCount) .. "]"
                    local cs, ce = src:find(close, i + #lb, true)
                    if cs then
                        for k = i, ce do if src:sub(k,k) == "\n" then line = line + 1 end end
                        i = ce + 1
                    else i = n + 1 end
                else
                    local nl = src:find("\n", i, true)
                    i = nl or (n + 1)
                end
            elseif c == "[" and src:match("^%[=*%[", i) then
                local lb = src:match("^%[=*%[", i)
                local eqCount = #lb - 2
                local close = "]" .. string.rep("=", eqCount) .. "]"
                local contentStart = i + #lb
                local cs, ce = src:find(close, contentStart, true)
                if cs then
                    push("STRING", src:sub(contentStart, cs - 1))
                    for k = i, ce do if src:sub(k,k) == "\n" then line = line + 1 end end
                    i = ce + 1
                else
                    push("STRING", src:sub(contentStart))
                    i = n + 1
                end
            elseif c == '"' or c == "'" then
                local quote = c
                local start = i + 1
                local j = start
                local parts = {}
                while j <= n do
                    local cc = src:sub(j, j)
                    if cc == "\\" then
                        local esc = src:sub(j+1, j+1)
                        local map = { n="\n", t="\t", r="\r", ["\\"]="\\", ['"']='"', ["'"]="'" }
                        table.insert(parts, map[esc] or esc)
                        j = j + 2
                    elseif cc == quote then break
                    else
                        if cc == "\n" then line = line + 1 end
                        table.insert(parts, cc)
                        j = j + 1
                    end
                end
                push("STRING", table.concat(parts))
                i = j + 1
            elseif isDigit(c) or (c == "." and isDigit(src:sub(i+1, i+1))) then
                local numStr = src:match("^0[xX]%x+", i) or src:match("^%d+%.?%d*[eE]?[%+%-]?%d*", i) or src:match("^%.%d+", i)
                push("NUMBER", tonumber(numStr) or 0)
                i = i + #numStr
            elseif isIdentStart(c) then
                local s = i
                while i <= n and isIdentChar(src:sub(i, i)) do i = i + 1 end
                local word = src:sub(s, i - 1)
                if KEYWORDS[word] then push("KEYWORD", word)
                else push("IDENT", word) end
            else
                local twoChar = src:sub(i, i+1)
                local threeChar = src:sub(i, i+2)
                if threeChar == "..." then push("PUNCT", "..."); i = i + 3
                elseif twoChar == "==" or twoChar == "~=" or twoChar == "<=" or twoChar == ">="
                    or twoChar == ".." or twoChar == "::" or twoChar == "->" then
                    push("OP", twoChar); i = i + 2
                else push("PUNCT", c); i = i + 1 end
            end
        end
        push("EOF", "")
        return tokens
    end

    -- =========================================================
    -- BLOK C: LUAU PARSER
    -- =========================================================
    local Parser = {}
    Parser.__index = Parser

    function Parser.new(tokens)
        return setmetatable({ tokens = tokens, pos = 1, depth = 0 }, Parser)
    end
    function Parser:peek() return self.tokens[self.pos] or { type = "EOF", value = "" } end
    function Parser:next()
        local t = self.tokens[self.pos] or { type = "EOF", value = "" }
        self.pos = self.pos + 1
        return t
    end
    function Parser:check(t, v)
        local tk = self:peek()
        if tk.type ~= t then return false end
        if v and tk.value ~= v then return false end
        return true
    end
    function Parser:accept(t, v) if self:check(t, v) then return self:next() end return nil end

    local parseExpr, parseBlock

    local function parsePrimary(self)
        self.depth = self.depth + 1
        if self.depth > V.cfg.maxASTDepth then
            self.depth = self.depth - 1
            return { type = "Error", msg = "max depth" }
        end

        local tk = self:peek()
        local node

        if tk.type == "NUMBER" then
            self:next(); node = { type = "Number", value = tk.value }
        elseif tk.type == "STRING" then
            self:next(); node = { type = "String", value = tk.value }
        elseif tk.type == "KEYWORD" then
            if tk.value == "true" or tk.value == "false" then
                self:next(); node = { type = "Bool", value = tk.value == "true" }
            elseif tk.value == "nil" then
                self:next(); node = { type = "Nil" }
            elseif tk.value == "function" then
                self:next()
                local params = {}
                if self:accept("PUNCT", "(") then
                    while not self:check("PUNCT", ")") and not self:check("EOF") do
                        if self:check("IDENT") then table.insert(params, self:next().value)
                        elseif self:check("PUNCT", "...") then self:next(); table.insert(params, "...")
                        else self:next() end
                        self:accept("PUNCT", ",")
                    end
                    self:accept("PUNCT", ")")
                end
                local body = parseBlock(self)
                node = { type = "Function", params = params, body = body }
            else self:next(); node = { type = "Keyword", value = tk.value } end
        elseif tk.type == "IDENT" then
            self:next(); node = { type = "Ident", name = tk.value }
        elseif tk.type == "PUNCT" and tk.value == "(" then
            self:next(); node = parseExpr(self); self:accept("PUNCT", ")")
        elseif tk.type == "PUNCT" and tk.value == "{" then
            self:next()
            local fields = {}
            while not self:check("PUNCT", "}") and not self:check("EOF") do
                if self:check("PUNCT", "[") then
                    self:next()
                    local k = parseExpr(self)
                    self:accept("PUNCT", "]")
                    self:accept("OP", "=")
                    local v = parseExpr(self)
                    table.insert(fields, { key = k, value = v })
                elseif self:check("IDENT") then
                    local savePos = self.pos
                    local name = self:next().value
                    if self:check("OP", "=") then
                        self:next()
                        local v = parseExpr(self)
                        table.insert(fields, { key = { type = "String", value = name }, value = v })
                    else
                        self.pos = savePos
                        local v = parseExpr(self)
                        table.insert(fields, { key = nil, value = v })
                    end
                else
                    local v = parseExpr(self)
                    table.insert(fields, { key = nil, value = v })
                end
                if not self:accept("PUNCT", ",") and not self:accept("PUNCT", ";") then break end
            end
            self:accept("PUNCT", "}")
            node = { type = "Table", fields = fields }
        else self:next(); node = { type = "Unknown", value = tk.value } end

        while true do
            if self:check("PUNCT", ".") then
                self:next()
                local name = self:next().value
                node = { type = "Member", obj = node, name = name }
            elseif self:check("PUNCT", "[") then
                self:next()
                local k = parseExpr(self)
                self:accept("PUNCT", "]")
                node = { type = "Index", obj = node, key = k }
            elseif self:check("PUNCT", ":") then
                self:next()
                local method = self:next().value
                local args = {}
                if self:accept("PUNCT", "(") then
                    while not self:check("PUNCT", ")") and not self:check("EOF") do
                        table.insert(args, parseExpr(self))
                        self:accept("PUNCT", ",")
                    end
                    self:accept("PUNCT", ")")
                elseif self:check("STRING") then
                    table.insert(args, { type = "String", value = self:next().value })
                end
                node = { type = "Call", obj = node, method = method, args = args }
            elseif self:check("PUNCT", "(") then
                self:next()
                local args = {}
                while not self:check("PUNCT", ")") and not self:check("EOF") do
                    table.insert(args, parseExpr(self))
                    self:accept("PUNCT", ",")
                end
                self:accept("PUNCT", ")")
                node = { type = "Call", obj = node, method = nil, args = args }
            else break end
        end

        self.depth = self.depth - 1
        return node
    end

    local function parseUnary(self)
        local tk = self:peek()
        if tk.type == "KEYWORD" and tk.value == "not" then
            self:next(); return { type = "UnaryOp", op = "not", expr = parseUnary(self) }
        end
        if tk.type == "PUNCT" and tk.value == "-" then
            self:next(); return { type = "UnaryOp", op = "-", expr = parseUnary(self) }
        end
        return parsePrimary(self)
    end

    local function parseBinary(self, minPrec)
        minPrec = minPrec or 0
        local precedence = {
            ["or"] = 1, ["and"] = 2,
            ["<"] = 3, [">"] = 3, ["<="] = 3, [">="] = 3, ["~="] = 3, ["=="] = 3,
            [".."] = 4, ["+"] = 5, ["-"] = 5, ["*"] = 6, ["/"] = 6, ["%"] = 6, ["^"] = 7,
        }
        local lhs = parseUnary(self)
        while true do
            local tk = self:peek()
            local op
            if tk.type == "KEYWORD" and (tk.value == "and" or tk.value == "or") then op = tk.value
            elseif tk.type == "OP" then op = tk.value
            elseif tk.type == "PUNCT" then op = tk.value end
            if not op or not precedence[op] or precedence[op] < minPrec then break end
            self:next()
            local rhs = parseBinary(self, precedence[op] + 1)
            lhs = { type = "BinaryOp", op = op, lhs = lhs, rhs = rhs }
        end
        return lhs
    end

    parseExpr = function(self) return parseBinary(self, 0) end

    parseBlock = function(self)
        local stmts = {}
        while not self:check("EOF") do
            local tk = self:peek()
            if tk.type == "KEYWORD" and (tk.value == "end" or tk.value == "else" or tk.value == "elseif" or tk.value == "until") then break end

            if tk.type == "KEYWORD" and tk.value == "local" then
                self:next()
                if self:check("KEYWORD", "function") then
                    self:next()
                    local name = self:next().value
                    local params = {}
                    if self:accept("PUNCT", "(") then
                        while not self:check("PUNCT", ")") and not self:check("EOF") do
                            if self:check("IDENT") then table.insert(params, self:next().value)
                            elseif self:check("PUNCT", "...") then self:next(); table.insert(params, "...")
                            else self:next() end
                            self:accept("PUNCT", ",")
                        end
                        self:accept("PUNCT", ")")
                    end
                    local body = parseBlock(self)
                    self:accept("KEYWORD", "end")
                    table.insert(stmts, { type = "LocalFunction", name = name, params = params, body = body })
                else
                    local names = {}
                    while self:check("IDENT") do
                        table.insert(names, self:next().value)
                        if not self:accept("PUNCT", ",") then break end
                    end
                    local values = {}
                    if self:accept("OP", "=") then
                        while true do
                            table.insert(values, parseExpr(self))
                            if not self:accept("PUNCT", ",") then break end
                        end
                    end
                    table.insert(stmts, { type = "LocalAssign", names = names, values = values })
                end
            elseif tk.type == "KEYWORD" and tk.value == "if" then
                self:next()
                local cond = parseExpr(self)
                self:accept("KEYWORD", "then")
                local thenBlock = parseBlock(self)
                local elseBlock = {}
                while self:check("KEYWORD", "elseif") do
                    self:next()
                    local c2 = parseExpr(self)
                    self:accept("KEYWORD", "then")
                    local b2 = parseBlock(self)
                    table.insert(elseBlock, { type = "ElseIf", cond = c2, body = b2 })
                end
                if self:accept("KEYWORD", "else") then elseBlock = parseBlock(self) end
                self:accept("KEYWORD", "end")
                table.insert(stmts, { type = "If", cond = cond, thenBlock = thenBlock, elseBlock = elseBlock })
            elseif tk.type == "KEYWORD" and tk.value == "while" then
                self:next()
                local cond = parseExpr(self)
                self:accept("KEYWORD", "do")
                local body = parseBlock(self)
                self:accept("KEYWORD", "end")
                table.insert(stmts, { type = "While", cond = cond, body = body })
            elseif tk.type == "KEYWORD" and tk.value == "for" then
                self:next()
                local var1 = self:next().value
                local var2
                if self:accept("PUNCT", ",") then var2 = self:next().value end
                self:accept("KEYWORD", "in")
                local iter = parseExpr(self)
                self:accept("KEYWORD", "do")
                local body = parseBlock(self)
                self:accept("KEYWORD", "end")
                table.insert(stmts, { type = "For", vars = { var1, var2 }, iter = iter, body = body })
            elseif tk.type == "KEYWORD" and tk.value == "return" then
                self:next()
                local vals = {}
                if not self:check("KEYWORD", "end") and not self:check("EOF") then
                    while true do
                        table.insert(vals, parseExpr(self))
                        if not self:accept("PUNCT", ",") then break end
                    end
                end
                table.insert(stmts, { type = "Return", values = vals })
            elseif tk.type == "KEYWORD" and tk.value == "function" then
                self:next()
                local name = self:next().value
                while self:accept("PUNCT", ".") do name = name .. "." .. self:next().value end
                local params = {}
                if self:accept("PUNCT", "(") then
                    while not self:check("PUNCT", ")") and not self:check("EOF") do
                        if self:check("IDENT") then table.insert(params, self:next().value)
                        else self:next() end
                        self:accept("PUNCT", ",")
                    end
                    self:accept("PUNCT", ")")
                end
                local body = parseBlock(self)
                self:accept("KEYWORD", "end")
                table.insert(stmts, { type = "FunctionDecl", name = name, params = params, body = body })
            elseif tk.type == "KEYWORD" and (tk.value == "break" or tk.value == "continue") then
                self:next()
                table.insert(stmts, { type = tk.value })
            else
                local expr = parseExpr(self)
                if self:check("OP", "=") or self:check("PUNCT", ",") then
                    local targets = { expr }
                    while self:accept("PUNCT", ",") do table.insert(targets, parseExpr(self)) end
                    self:accept("OP", "=")
                    local vals = {}
                    while true do
                        table.insert(vals, parseExpr(self))
                        if not self:accept("PUNCT", ",") then break end
                    end
                    table.insert(stmts, { type = "Assign", targets = targets, values = vals })
                else
                    table.insert(stmts, { type = "ExprStmt", expr = expr })
                end
            end
        end
        return stmts
    end

    local function parseSource(src)
        local ok, tokensOrErr = pcall(tokenize, src)
        if not ok then return nil, "tokenize failed: " .. tostring(tokensOrErr) end
        local parser = Parser.new(tokensOrErr)
        local ok2, astOrErr = pcall(function()
            local stmts = parseBlock(parser)
            return { type = "Program", body = stmts }
        end)
        if not ok2 then return nil, "parse failed: " .. tostring(astOrErr) end
        return astOrErr, nil
    end

    -- =========================================================
    -- BLOK D: SCRIPT DUMPER (v1.4 - with placeholder detection)
    -- =========================================================

    -- Deteksi apakah string adalah placeholder/invalid
    local function isPlaceholderSource(src)
        if not src or type(src) ~= "string" then return true end
        local trimmed = src:gsub("^%s+", ""):gsub("%s+$", "")
        if #trimmed < 50 then return true end
        local lower = trimmed:lower()
        if lower:find("unavailable", 1, true) then return true end
        if lower:find("decompiler", 1, true) and #trimmed < 200 then return true end
        if lower:find("cannot decompile", 1, true) then return true end
        if lower:find("failed to", 1, true) and #trimmed < 200 then return true end
        if lower:find("bytecode only", 1, true) then return true end
        if lower:find("not available", 1, true) then return true end
        if lower:find("error:", 1, true) and #trimmed < 200 then return true end
        local onlyComment = true
        for line in trimmed:gmatch("[^\n]+") do
            local lt = line:gsub("^%s+", "")
            if lt ~= "" and not lt:match("^%-%-") then
                onlyComment = false
                break
            end
        end
        if onlyComment and #trimmed < 200 then return true end
        return false
    end

    -- Coba berbagai metode decompile
    local function tryGetSource(scriptInstance)
        local errors = {}

        -- Method 1: .Source property
        local ok, src = pcall(function() return scriptInstance.Source end)
        if ok and type(src) == "string" and #src > 0 then
            if not isPlaceholderSource(src) then
                return src, "Source"
            end
            table.insert(errors, "Source: placeholder(" .. #src .. "B)")
        else
            table.insert(errors, "Source: " .. (ok and "empty" or tostring(src)))
        end

        -- Method 2: getscriptbytecode + decompile
        if type(getscriptbytecode) == "function" then
            local ok2, bytecode = pcall(getscriptbytecode, scriptInstance)
            if ok2 and type(bytecode) == "string" and #bytecode > 0 then
                if type(decompile) == "function" then
                    local ok3, dec = pcall(decompile, bytecode)
                    if ok3 and type(dec) == "string" and #dec > 0 then
                        if not isPlaceholderSource(dec) then
                            return dec, "decompile"
                        end
                        table.insert(errors, "decompile: placeholder(" .. #dec .. "B)")
                    else
                        table.insert(errors, "decompile: " .. tostring(dec))
                    end
                end
                if type(decompiler) == "function" then
                    local ok4, dec2 = pcall(decompiler, bytecode)
                    if ok4 and type(dec2) == "string" and #dec2 > 0 and not isPlaceholderSource(dec2) then
                        return dec2, "decompiler"
                    end
                end
            else
                table.insert(errors, "bytecode: " .. (ok2 and "empty" or "err"))
            end
        end

        -- Method 3: getscriptclosure + debug.info
        if type(getscriptclosure) == "function" then
            local ok5, closure = pcall(getscriptclosure, scriptInstance)
            if ok5 and type(closure) == "function" then
                if type(debug) == "table" and type(debug.info) == "function" then
                    local ok6, src2 = pcall(debug.info, closure, "s")
                    if ok6 and type(src2) == "string" and #src2 > 0 and not isPlaceholderSource(src2) then
                        return src2, "debug.info"
                    end
                end
            end
        end

        return nil, table.concat(errors, " | ")
    end

    local function safeAddRoot(roots, parent)
        if not parent then return end
        local ok = pcall(function() local _ = parent.Name end)
        if ok then table.insert(roots, parent) end
    end

    local function collectScripts()
        local results = {}
        local roots = {}

        safeAddRoot(roots, game:GetService("ReplicatedStorage"))
        safeAddRoot(roots, game:GetService("ReplicatedFirst"))
        safeAddRoot(roots, game:GetService("StarterGui"))
        safeAddRoot(roots, game:GetService("StarterPlayer"))
        safeAddRoot(roots, game:GetService("StarterPack"))
        safeAddRoot(roots, workspace)

        if LocalPlayer then
            local ps = LocalPlayer:FindFirstChild("PlayerScripts")
            if ps then table.insert(roots, ps) end
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(roots, pg) end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then table.insert(roots, bp) end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            local char = plr and plr.Character
            if char then table.insert(roots, char) end
        end

        local seenRoot = {}
        local uniqueRoots = {}
        for _, r in ipairs(roots) do
            if not seenRoot[r] then
                seenRoot[r] = true
                table.insert(uniqueRoots, r)
            end
        end

        local seen = {}
        for _, root in ipairs(uniqueRoots) do
            local ok, descendants = pcall(function() return root:GetDescendants() end)
            if ok and descendants then
                for _, obj in ipairs(descendants) do
                    local isScript = obj:IsA("LocalScript") or obj:IsA("ModuleScript") or obj:IsA("Script")
                    if isScript and not seen[obj] then
                        seen[obj] = true
                        local pathOk, path = pcall(function() return obj:GetFullName() end)
                        path = pathOk and path or ("<" .. tostring(obj.Name) .. ">")

                        local srcOk, src, method = pcall(function() return tryGetSource(obj) end)
                        if srcOk and type(src) == "string" and #src > 0 then
                            table.insert(results, {
                                path = path, className = obj.ClassName,
                                source = src, method = method or "?", size = #src,
                                valid = true,
                            })
                        else
                            table.insert(results, {
                                path = path, className = obj.ClassName,
                                source = "", method = "FAILED", size = 0,
                                valid = false,
                                note = (srcOk and method) or tostring(src),
                            })
                        end
                    end
                end
            end
        end
        return results
    end

    -- DUMP SAMPLE function
    function V:dumpScriptSamples(limit)
        limit = limit or 5
        print("[VANZ] ===== SCRIPT SOURCE SAMPLES =====")
        local shown = 0
        for _, info in ipairs(self.staticScripts) do
            if info.valid and shown < limit then
                shown = shown + 1
                print("")
                print("--- SAMPLE #" .. shown .. " ---")
                print("PATH   : " .. info.path)
                print("CLASS  : " .. info.className)
                print("METHOD : " .. info.method)
                print("SIZE   : " .. info.size .. " bytes")
                print("FIRST 500 CHARS:")
                print(info.source:sub(1, 500))
            end
        end
        print("")
        print("[VANZ] ===== END SAMPLES (" .. shown .. " shown) =====")
        if shown == 0 then
            print("[VANZ] GA ADA script valid. Decompiler lu ga support game ini.")
            print("[VANZ] Coba executor lain: Codex, Arceus X, Hydrogen.")
        end
    end

    -- =========================================================
    -- BLOK E: RULE ENGINE
    -- =========================================================
    local function walkNode(node, visitor)
        if type(node) ~= "table" then return end
        visitor(node)
        for k, v in pairs(node) do
            if k ~= "parent" and type(v) == "table" then
                if v.type then walkNode(v, visitor)
                elseif #v > 0 then
                    for _, item in ipairs(v) do
                        if type(item) == "table" and item.type then walkNode(item, visitor) end
                    end
                end
            end
        end
    end

    local REMOTE_METHODS = { FireServer = true, InvokeServer = true, FireClient = true, InvokeClient = true, Fire = true, Invoke = true }

    local function analyzeAST(ast, scriptInfo, outFindings)
        local remoteCalls = {}
        local stringLiterals = {}
        local connectCalls = {}
        local getServiceCalls = {}

        local function visit(node)
            if node.type == "Call" and node.method and REMOTE_METHODS[node.method] then
                local remoteName = nil
                local obj = node.obj
                if obj and obj.type == "Member" then remoteName = obj.name
                elseif obj and obj.type == "Ident" then remoteName = obj.name
                elseif obj and obj.type == "Index" and obj.key and obj.key.type == "String" then remoteName = obj.key.value end
                table.insert(remoteCalls, { method = node.method, remoteName = remoteName, argCount = #node.args })
            end
            if node.type == "String" then
                table.insert(stringLiterals, { value = node.value })
            end
            if node.type == "Call" and node.method == "Connect" then
                local handler = node.args and node.args[1]
                if handler and handler.type == "Function" then
                    table.insert(connectCalls, { params = handler.params, body = handler.body })
                end
            end
            if node.type == "Call" and node.obj and node.obj.type == "Ident" and node.obj.name == "GetService" then
                local svcArg = node.args and node.args[1]
                if svcArg and svcArg.type == "String" then
                    table.insert(getServiceCalls, { service = svcArg.value })
                end
            end
        end

        walkNode(ast, visit)

        for _, sl in ipairs(stringLiterals) do
            local v = sl.value
            if type(v) == "string" and #v >= 16 then
                local isSecret, why = false, nil
                if v:match("^https://discord%.com/api/webhooks/") then isSecret, why = true, "Discord webhook URL"
                elseif v:match("^[A-Za-z0-9_%-]+%.[A-Za-z0-9_%-]+%.[A-Za-z0-9_%-]+$") and #v > 40 then isSecret, why = true, "JWT-like token"
                elseif v:match("^sk_live_") or v:match("^pk_live_") or v:match("^AKIA[0-9A-Z]+") or v:match("^ghp_[A-Za-z0-9]+") then isSecret, why = true, "Known API key prefix"
                elseif #v > 32 and v:match("^[A-Za-z0-9+/=]+$") then
                    if v:match("[A-Z]") and v:match("[a-z]") and v:match("%d") then
                        isSecret, why = true, "High-entropy base64"
                    end
                end
                if isSecret then
                    table.insert(outFindings, {
                        rule = "R006", severity = V.cfg.ruleSeverities.R006,
                        title = "Hardcoded Secret in Client Script",
                        script = scriptInfo.path, className = scriptInfo.className,
                        evidence = "String: " .. v:sub(1, 80), context = why,
                        snippet = v:sub(1, 100),
                        interpretation = "Secret-like value di client code.",
                        recommendation = "Pindahkan ke server-side.",
                    })
                end
            end
            if type(v) == "string" and v:match("^https?://") and not v:match("discord%.com/api/webhooks") then
                table.insert(outFindings, {
                    rule = "R010", severity = V.cfg.ruleSeverities.R010,
                    title = "External HTTP Endpoint in Client",
                    script = scriptInfo.path, className = scriptInfo.className,
                    evidence = "URL: " .. v, snippet = v,
                    interpretation = "Client punya URL ke endpoint eksternal.",
                    recommendation = "Pastikan endpoint public.",
                })
            end
        end

        for _, rc in ipairs(remoteCalls) do
            if rc.remoteName then
                table.insert(outFindings, {
                    rule = "R008", severity = V.cfg.ruleSeverities.R008,
                    title = "Remote Reference Detected",
                    script = scriptInfo.path, className = scriptInfo.className,
                    evidence = rc.method .. " | Remote: " .. rc.remoteName,
                    snippet = string.format("...:%s(%d args)", rc.method, rc.argCount),
                    interpretation = "Remote name ketemu di static.",
                    recommendation = "Cek dynamic traffic.",
                    remoteName = rc.remoteName, method = rc.method, argCount = rc.argCount, isStatic = true,
                })
            end
        end

        for _, sl in ipairs(stringLiterals) do
            local lower = sl.value:lower()
            if lower == "admin" or lower == "debug" or lower == "test" or lower == "dev" or lower == "godmode" then
                table.insert(outFindings, {
                    rule = "R011", severity = V.cfg.ruleSeverities.R011,
                    title = "Debug/Admin Keyword",
                    script = scriptInfo.path, className = scriptInfo.className,
                    evidence = "String: " .. sl.value, snippet = sl.value,
                    interpretation = "Kata kunci debug/admin di string literal.",
                    recommendation = "Audit apakah flag ini reachable.",
                })
            end
        end

        for _, gs in ipairs(getServiceCalls) do
            if gs.service == "DataStoreService" then
                table.insert(outFindings, {
                    rule = "R009", severity = V.cfg.ruleSeverities.R009,
                    title = "DataStoreService Referenced in Client",
                    script = scriptInfo.path, className = scriptInfo.className,
                    evidence = "GetService(\"DataStoreService\")",
                    snippet = "...:GetService(\"DataStoreService\")",
                    interpretation = "DataStore usually server-only.",
                    recommendation = "Kalo client bisa akses DataStore, itu issue.",
                })
            end
        end

        for _, cc in ipairs(connectCalls) do
            if cc.params and #cc.params > 1 and cc.body then
                local hasIf = false
                local count = 0
                for _, stmt in ipairs(cc.body) do
                    if stmt.type == "If" then hasIf = true; count = count + 1 end
                end
                if hasIf and count <= 2 and #cc.params >= 2 then
                    table.insert(outFindings, {
                        rule = "R007", severity = V.cfg.ruleSeverities.R007,
                        title = "Client-Side Validation Pattern",
                        script = scriptInfo.path, className = scriptInfo.className,
                        evidence = string.format("Handler %d params, %d if-statements", #cc.params, count),
                        snippet = "handler:Connect(function(" .. table.concat(cc.params, ", ") .. ") if ... end)",
                        interpretation = "Handler dengan validasi minimal.",
                        recommendation = "Cek apakah server-side validasi lebih ketat.",
                    })
                end
            end
        end
    end

    -- =========================================================
    -- BLOK F: RUN STATIC SCAN (v1.4)
    -- =========================================================
    function V:runStaticScan()
        self.staticState = "running"
        self.staticScripts = {}
        self.staticFindings = {}
        self.staticError = nil
        self.staticProgress = { total = 0, done = 0, current = "" }

        print("[VANZ] STATIC SCAN START")

        local ok, scripts = pcall(collectScripts)
        if not ok then
            self.staticError = "collect failed: " .. tostring(scripts)
            self.staticState = "error"
            return
        end

        self.staticProgress.total = #scripts
        local validCount = 0
        local failedCount = 0
        local placeholderCount = 0

        for idx, info in ipairs(scripts) do
            self.staticProgress.done = idx
            self.staticProgress.current = info.path

            if info.valid and info.source and #info.source > 50 then
                local ast, err = parseSource(info.source)
                if ast then
                    info.ast = ast
                    info.parseOk = true
                    validCount = validCount + 1
                    local findings = {}
                    pcall(analyzeAST, ast, info, findings)
                    info.findings = findings
                    for _, f in ipairs(findings) do table.insert(self.staticFindings, f) end
                else
                    info.parseOk = false
                    info.parseError = err
                    failedCount = failedCount + 1
                end
            else
                info.parseOk = false
                info.parseError = info.note or "invalid source"
                placeholderCount = placeholderCount + 1
            end
            table.insert(self.staticScripts, info)
            task.wait()
        end

        self.staticState = "done"
        self.staticProgress.current = ""

        print("[VANZ] STATIC SCAN DONE")
        print("[VANZ] Valid parsed: " .. validCount)
        print("[VANZ] Parse failed: " .. failedCount)
        print("[VANZ] Placeholder/invalid: " .. placeholderCount)
        print("[VANZ] Findings: " .. #self.staticFindings)

        if validCount == 0 then
            print("[VANZ] WARNING: 0 valid script parsed.")
            print("[VANZ] Decompiler lu ga support game ini.")
            print("[VANZ] Klik 1.0 DUMP SAMPLE buat liat output.")
        end
    end

    -- =========================================================
    -- BLOK G: CROSS-REFERENCE
    -- =========================================================
    function V:runCrossReference()
        self.crossState = "running"
        self.crossFindings = {}
        self.crossStartedAt = tick()

        print("[VANZ] CROSS-REF START")

        if self.staticState ~= "done" then
            print("[VANZ] Run STATIC dulu.")
            self.crossState = "error"
            return
        end

        local dynamicRemotes = {}
        for remoteName, stat in pairs(self.liveStats) do dynamicRemotes[remoteName] = stat end

        local staticRemotes = {}
        for _, f in ipairs(self.staticFindings) do
            if f.rule == "R008" and f.remoteName then
                staticRemotes[f.remoteName] = staticRemotes[f.remoteName] or {}
                table.insert(staticRemotes[f.remoteName], f)
            end
        end

        local hiddenRemotes = {}
        for sName, sFindings in pairs(staticRemotes) do
            local found = false
            for dName, _ in pairs(dynamicRemotes) do
                if dName:find(sName, 1, true) then found = true; break end
            end
            if not found then table.insert(hiddenRemotes, { name = sName, findings = sFindings }) end
        end

        local orphanRemotes = {}
        for dName, stat in pairs(dynamicRemotes) do
            local found = false
            for sName, _ in pairs(staticRemotes) do
                if dName:find(sName, 1, true) then found = true; break end
            end
            if not found then table.insert(orphanRemotes, { name = dName, stat = stat }) end
        end

        for _, hr in ipairs(hiddenRemotes) do
            table.insert(self.crossFindings, {
                rule = "X001", severity = "HIGH",
                title = "Hidden Remote (Static-only)",
                remote = hr.name,
                evidence = "Static-only, ga muncul di dynamic.",
                interpretation = "Remote ini butuh kondisi khusus untuk di-trigger.",
                recommendation = "Audit source code, cari pemicu.",
            })
        end

        for _, orph in ipairs(orphanRemotes) do
            table.insert(self.crossFindings, {
                rule = "X002", severity = "MEDIUM",
                title = "Orphan Remote (Dynamic-only)",
                remote = orph.name,
                evidence = "Dynamic-only, ga ketemu di static.",
                interpretation = "Remote dari code yang ga kita akses.",
                recommendation = "Cek ReplicatedStorage manual.",
            })
        end

        for _, f in ipairs(self.staticFindings) do
            if f.rule == "R006" then
                table.insert(self.crossFindings, {
                    rule = "X003", severity = "CRITICAL",
                    title = "Hardcoded Secret Exposed",
                    remote = f.script,
                    evidence = f.evidence,
                    interpretation = f.interpretation,
                    recommendation = f.recommendation,
                })
            end
        end

        self.crossState = "done"
        self.crossDoneAt = tick()
        print("[VANZ] CROSS-REF DONE | findings=" .. #self.crossFindings)
    end

    -- =========================================================
    -- BLOK H: REPORT BUILDERS
    -- =========================================================
    local function line(lines, text) lines[#lines + 1] = text end

    function V:buildStaticReport()
        local lines = {}
        line(lines, "============================================================")
        line(lines, "         VANZHUB STATIC ANALYSIS REPORT v1.4")
        line(lines, "============================================================")
        line(lines, "Generated     : " .. os.date("%Y-%m-%d %H:%M:%S"))
        line(lines, "Scripts found : " .. #self.staticScripts)

        local parseable, unparseable, placeholder = 0, 0, 0
        for _, s in ipairs(self.staticScripts) do
            if s.parseOk then parseable = parseable + 1
            elseif not s.valid then placeholder = placeholder + 1
            else unparseable = unparseable + 1 end
        end
        line(lines, "Parseable     : " .. parseable)
        line(lines, "Unparseable   : " .. unparseable)
        line(lines, "Placeholder   : " .. placeholder)
        line(lines, "Findings      : " .. #self.staticFindings)
        line(lines, "")
        if parseable == 0 and #self.staticScripts > 0 then
            line(lines, "WARNING: Tidak ada script yang berhasil di-parse.")
            line(lines, "Decompiler executor tidak support game ini.")
            line(lines, "Coba Codex, Arceus X, atau Hydrogen.")
            line(lines, "")
        end
        line(lines, "SECTION A: SCRIPT INVENTORY (summary)")
        line(lines, "============================================================")

        local byClass = { LocalScript = 0, ModuleScript = 0, Script = 0 }
        for _, s in ipairs(self.staticScripts) do
            if byClass[s.className] then byClass[s.className] = byClass[s.className] + 1 end
        end
        for cls, count in pairs(byClass) do
            line(lines, "  [" .. cls .. "] " .. count .. " scripts")
        end

        line(lines, "")
        line(lines, "SECTION B: STATIC FINDINGS")
        line(lines, "============================================================")
        if #self.staticFindings == 0 then
            line(lines, "No static findings.")
        else
            for i, f in ipairs(self.staticFindings) do
                line(lines, "")
                line(lines, "STATIC #" .. i .. " [" .. f.severity .. "] [" .. f.rule .. "]")
                line(lines, "Title      : " .. f.title)
                line(lines, "Script     : " .. f.script)
                line(lines, "Class      : " .. f.className)
                if f.context then line(lines, "Context    : " .. f.context) end
                line(lines, "Evidence   : " .. f.evidence)
                if f.snippet then line(lines, "Snippet    : " .. f.snippet) end
                line(lines, "Interpret  : " .. f.interpretation)
                line(lines, "Recommend  : " .. f.recommendation)
            end
        end
        line(lines, "")
        line(lines, "END OF STATIC REPORT")
        return table.concat(lines, "\n")
    end

    function V:buildCrossReport()
        local lines = {}
        line(lines, "============================================================")
        line(lines, "         VANZHUB CROSS-REFERENCE REPORT")
        line(lines, "============================================================")
        line(lines, "Generated     : " .. os.date("%Y-%m-%d %H:%M:%S"))
        line(lines, "Static state  : " .. self.staticState)
        line(lines, "Dynamic state : " .. self.sessionState)
        line(lines, "Cross findings: " .. #self.crossFindings)
        line(lines, "")
        if #self.crossFindings == 0 then
            line(lines, "No cross findings.")
        else
            for i, f in ipairs(self.crossFindings) do
                line(lines, "CROSS #" .. i .. " [" .. f.severity .. "] [" .. f.rule .. "]")
                line(lines, "Title    : " .. f.title)
                line(lines, "Remote   : " .. f.remote)
                line(lines, "Evidence : " .. f.evidence)
                line(lines, "Interpret: " .. f.interpretation)
                line(lines, "Recommend: " .. f.recommendation)
                line(lines, "")
            end
        end
        line(lines, "END OF CROSS REPORT")
        return table.concat(lines, "\n")
    end

    -- =========================================================
    -- BLOK I: GUI
    -- =========================================================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VanzScanner"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    pcall(function() ScreenGui.Parent = CoreGui end)
    if not ScreenGui.Parent then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    V.ScreenGui = ScreenGui

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, W, 0.95, 0)
    Main.Position = UDim2.new(0, 10, 0.5, 0)
    Main.AnchorPoint = Vector2.new(0, 0.5)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
    Main.BorderSizePixel = 0
    Main.Active = true
    Main.Draggable = true
    Main.Parent = ScreenGui
    V.Main = Main
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local MainStroke = Instance.new("UIStroke", Main)
    MainStroke.Color = Color3.fromRGB(60, 60, 80)
    MainStroke.Thickness = 1

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 8)

    local TitleFix = Instance.new("Frame")
    TitleFix.Size = UDim2.new(1, 0, 0, 12)
    TitleFix.Position = UDim2.new(0, 0, 1, -12)
    TitleFix.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    TitleFix.BorderSizePixel = 0
    TitleFix.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "VANZHUB • STATIC ANALYZER v1.4"
    Title.TextColor3 = Color3.fromRGB(235, 235, 245)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 10
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(1, -48, 0.5, -4)
    StatusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = TitleBar
    Instance.new("UICorner", StatusDot).CornerRadius = UDim.new(1, 0)
    V.StatusDot = StatusDot

    local MinBtn = Instance.new("TextButton")
    MinBtn.Size = UDim2.new(0, 24, 0, 22)
    MinBtn.Position = UDim2.new(1, -32, 0, 4)
    MinBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 68)
    MinBtn.Text = "–"
    MinBtn.TextColor3 = Color3.fromRGB(235, 235, 245)
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.TextSize = 14
    MinBtn.BorderSizePixel = 0
    MinBtn.Parent = TitleBar
    Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 4)
    V.MinBtn = MinBtn

    local TabBar = Instance.new("Frame")
    TabBar.Position = UDim2.new(0, 8, 0, 36)
    TabBar.Size = UDim2.new(1, -16, 0, 24)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = Main
    local TabLayout = Instance.new("UIListLayout", TabBar)
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local ContentWrap = Instance.new("Frame")
    ContentWrap.Position = UDim2.new(0, 8, 0, 66)
    ContentWrap.Size = UDim2.new(1, -16, 1, -74)
    ContentWrap.BackgroundTransparency = 1
    ContentWrap.Parent = Main

    local function makeScrollTab()
        local sf = Instance.new("ScrollingFrame")
        sf.Size = UDim2.new(1, 0, 1, 0)
        sf.BackgroundTransparency = 1
        sf.BorderSizePixel = 0
        sf.ScrollBarThickness = 4
        sf.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
        sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sf.CanvasSize = UDim2.new(0, 0, 0, 0)
        sf.Visible = false
        sf.Parent = ContentWrap
        local l = Instance.new("UIListLayout", sf)
        l.Padding = UDim.new(0, 4)
        l.SortOrder = Enum.SortOrder.LayoutOrder
        return sf
    end

    local TabStatic = makeScrollTab()
    local TabDynamic = makeScrollTab()
    local TabCross = makeScrollTab()
    local TabStatus = makeScrollTab()

    local TabButtons = {}
    local function makeTabButton(text, target)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 78, 1, 0)
        b.BackgroundColor3 = Color3.fromRGB(32, 32, 44)
        b.Text = text
        b.TextColor3 = Color3.fromRGB(180, 180, 200)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 9
        b.BorderSizePixel = 0
        b.Parent = TabBar
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        table.insert(TabButtons, { btn = b, frame = target })
        b.MouseButton1Click:Connect(function()
            for _, item in ipairs(TabButtons) do
                local active = item.frame == target
                item.frame.Visible = active
                item.btn.BackgroundColor3 = active and Color3.fromRGB(60, 50, 100) or Color3.fromRGB(32, 32, 44)
                item.btn.TextColor3 = active and Color3.fromRGB(235, 235, 245) or Color3.fromRGB(180, 180, 200)
            end
        end)
        return b
    end

    local BtnStatic = makeTabButton("1.STATIC", TabStatic)
    local BtnDynamic = makeTabButton("2.DYNAMIC", TabDynamic)
    local BtnCross = makeTabButton("3.CROSS", TabCross)
    local BtnStatus = makeTabButton("4.STATUS", TabStatus)
    BtnStatic.BackgroundColor3 = Color3.fromRGB(60, 50, 100)
    BtnStatic.TextColor3 = Color3.fromRGB(235, 235, 245)

    local function makeSection(parent, text, color)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, 20)
        l.BackgroundTransparency = 1
        l.Text = text
        l.TextColor3 = color or Color3.fromRGB(150, 130, 255)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Parent = parent
        return l
    end

    local function makeBtn(parent, text, color, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 26)
        b.BackgroundColor3 = color
        b.Text = text
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.BorderSizePixel = 0
        b.Parent = parent
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
        b.MouseButton1Click:Connect(cb)
        return b
    end

    local function makeInfoLabel(parent, initialText, height)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, 0, 0, height or 60)
        l.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        l.BorderSizePixel = 0
        l.Text = initialText
        l.TextColor3 = Color3.fromRGB(200, 200, 220)
        l.Font = Enum.Font.Code
        l.TextSize = 9
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextYAlignment = Enum.TextYAlignment.Top
        l.TextWrapped = true
        l.Parent = parent
        Instance.new("UICorner", l).CornerRadius = UDim.new(0, 5)
        local pad = Instance.new("UIPadding", l)
        pad.PaddingTop = UDim.new(0, 4); pad.PaddingLeft = UDim.new(0, 6)
        pad.PaddingRight = UDim.new(0, 6); pad.PaddingBottom = UDim.new(0, 4)
        return l
    end

    -- =========================================================
    -- TAB 1: STATIC
    -- =========================================================
    local ST = TabStatic
    makeSection(ST, "STEP 1 一 STATIC ANALYSIS", Color3.fromRGB(150, 130, 255))

    makeBtn(ST, "1.0  DUMP SCRIPT SAMPLES", Color3.fromRGB(140, 100, 80), function()
        if V.staticState == "none" then
            print("[VANZ] Run 1.1 dulu (perlu data script).")
            return
        end
        setStep("1.0", "proses")
        V:dumpScriptSamples(5)
        setStep("1.0", "selesai", "check console")
    end)

    makeBtn(ST, "1.1  RUN STATIC SCAN", Color3.fromRGB(100, 150, 220), function()
        if V.steps["1.1"].state == "proses" then
            print("[VANZ] Static scan masih jalan.")
            return
        end
        setStep("1.1", "proses")
        task.spawn(function()
            local ok, err = pcall(function() V:runStaticScan() end)
            if ok and V.staticState == "done" then
                setStep("1.1", "selesai")
            else
                setStep("1.1", "error", tostring(err or V.staticError))
            end
        end)
    end)

    local staticStatus = makeInfoLabel(ST,
        "Status: BELUM\nValid: 0 | Failed: 0 | Placeholder: 0\nTotal: 0 | Findings: 0\nProgress: 0/0\nCurrent: -", 95)
    V.StaticStatusLabel = staticStatus

    makeBtn(ST, "1.2  COPY STATIC REPORT", Color3.fromRGB(0, 136, 204), function()
        if V.staticState ~= "done" then
            print("[VANZ] Run 1.1 dulu.")
            return
        end
        setStep("1.2", "proses")
        local report = V:buildStaticReport()
        if type(setclipboard) == "function" then
            local ok = pcall(function() setclipboard(report) end)
            if ok then
                setStep("1.2", "selesai", #report .. " chars")
                print("[VANZ] Static report copied: " .. #report .. " char")
            else
                setStep("1.2", "error", "clipboard fail")
            end
        else
            setStep("1.2", "error", "no clipboard")
        end
    end)

    makeBtn(ST, "1.3  CLEAR STATIC DATA", Color3.fromRGB(150, 70, 70), function()
        setStep("1.3", "proses")
        V.staticScripts = {}
        V.staticFindings = {}
        V.staticState = "none"
        V.staticError = nil
        setStep("1.3", "selesai")
        setStep("1.1", "belum")
        setStep("1.2", "belum")
        setStep("1.0", "belum")
        print("[VANZ] Static data cleared.")
    end)

    -- =========================================================
    -- TAB 2: DYNAMIC
    -- =========================================================
    local DT = TabDynamic
    makeSection(DT, "STEP 2 一 DYNAMIC SESSION", Color3.fromRGB(150, 200, 255))

    makeBtn(DT, "2.1  START SESSION", Color3.fromRGB(70, 130, 200), function()
        if V.sessionState == "recording" then
            print("[VANZ] Session udah recording.")
            return
        end
        setStep("2.1", "proses")
        V.liveStats = {}
        V._rawNC = {}
        V.captured = {}
        V.counter = 0
        V.sessionOn = true
        V.enabled = true
        V.sessionState = "recording"
        V.sessionStartedAt = tick()
        V.sessionStoppedAt = 0
        if V.StatusDot then V.StatusDot.BackgroundColor3 = Color3.fromRGB(80, 200, 120) end
        setStep("2.1", "selesai")
        setStep("2.2", "belum")
        print("[VANZ] SESSION START 一 main normal")
    end)

    makeBtn(DT, "2.2  STOP SESSION", Color3.fromRGB(200, 130, 70), function()
        if not V.sessionOn then
            print("[VANZ] Session ga aktif.")
            return
        end
        setStep("2.2", "proses")
        V.sessionOn = false
        V.enabled = false
        V.sessionState = "stopped"
        V.sessionStoppedAt = tick()
        if V.StatusDot then V.StatusDot.BackgroundColor3 = Color3.fromRGB(180, 60, 60) end
        setStep("2.2", "selesai")
        print("[VANZ] SESSION STOPPED")
    end)

    local dynStatus = makeInfoLabel(DT,
        "State: BELUM\nRemotes: 0 | Calls: 0\nDuration: 0s", 60)
    V.DynamicStatusLabel = dynStatus

    makeSection(DT, "INFO", Color3.fromRGB(150, 200, 255))
    local dynInfo = Instance.new("TextLabel")
    dynInfo.Size = UDim2.new(1, 0, 0, 80)
    dynInfo.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    dynInfo.BorderSizePixel = 0
    dynInfo.Text = "Catatan:\n- Session nangkep semua FireServer/InvokeServer\n- Remote di-rekam pake full path\n- Data dipake untuk cross-reference"
    dynInfo.TextColor3 = Color3.fromRGB(180, 180, 220)
    dynInfo.Font = Enum.Font.Code
    dynInfo.TextSize = 9
    dynInfo.TextXAlignment = Enum.TextXAlignment.Left
    dynInfo.TextYAlignment = Enum.TextYAlignment.Top
    dynInfo.TextWrapped = true
    dynInfo.Parent = DT
    Instance.new("UICorner", dynInfo).CornerRadius = UDim.new(0, 5)
    local dPad = Instance.new("UIPadding", dynInfo)
    dPad.PaddingTop = UDim.new(0, 4); dPad.PaddingLeft = UDim.new(0, 6)
    dPad.PaddingRight = UDim.new(0, 6); dPad.PaddingBottom = UDim.new(0, 4)

    -- =========================================================
    -- TAB 3: CROSS-REF
    -- =========================================================
    local CT = TabCross
    makeSection(CT, "STEP 3 一 CROSS-REFERENCE", Color3.fromRGB(255, 180, 120))

    makeBtn(CT, "3.1  RUN CROSS-REF", Color3.fromRGB(220, 130, 70), function()
        if V.steps["3.1"].state == "proses" then return end
        if V.staticState ~= "done" then
            print("[VANZ] Run 1.1 dulu.")
            return
        end
        if V.sessionState ~= "stopped" then
            print("[VANZ] Run 2.2 dulu (stop session).")
            return
        end
        setStep("3.1", "proses")
        task.spawn(function()
            local ok, err = pcall(function() V:runCrossReference() end)
            if ok and V.crossState == "done" then
                setStep("3.1", "selesai")
            else
                setStep("3.1", "error", tostring(err))
            end
        end)
    end)

    local crossStatus = makeInfoLabel(CT,
        "State: BELUM\nFindings: 0", 40)
    V.CrossStatusLabel = crossStatus

    makeBtn(CT, "3.2  COPY CROSS REPORT", Color3.fromRGB(0, 136, 204), function()
        if V.crossState ~= "done" then
            print("[VANZ] Run 3.1 dulu.")
            return
        end
        setStep("3.2", "proses")
        local report = V:buildCrossReport()
        if type(setclipboard) == "function" then
            local ok = pcall(function() setclipboard(report) end)
            if ok then
                setStep("3.2", "selesai", #report .. " chars")
                print("[VANZ] Cross report copied: " .. #report .. " char")
            else
                setStep("3.2", "error", "clipboard fail")
            end
        else
            setStep("3.2", "error", "no clipboard")
        end
    end)

    makeSection(CT, "LEGEND", Color3.fromRGB(255, 180, 120))
    local legend = Instance.new("TextLabel")
    legend.Size = UDim2.new(1, 0, 0, 100)
    legend.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
    legend.BorderSizePixel = 0
    legend.Text = "X001 = Hidden Remote (static only)\nX002 = Orphan Remote (dynamic only)\nX003 = Hardcoded Secret\n\nR001-R012 = Static findings\nCRITICAL = immediate attention\n\nUrutan pakai:\n1.1 -> 2.1 -> play -> 2.2 -> 3.1"
    legend.TextColor3 = Color3.fromRGB(200, 200, 220)
    legend.Font = Enum.Font.Code
    legend.TextSize = 9
    legend.TextXAlignment = Enum.TextXAlignment.Left
    legend.TextYAlignment = Enum.TextYAlignment.Top
    legend.TextWrapped = true
    legend.Parent = CT
    Instance.new("UICorner", legend).CornerRadius = UDim.new(0, 5)
    local lpad = Instance.new("UIPadding", legend)
    lpad.PaddingTop = UDim.new(0, 4); lpad.PaddingLeft = UDim.new(0, 6)
    lpad.PaddingRight = UDim.new(0, 6); lpad.PaddingBottom = UDim.new(0, 4)

    makeSection(CT, "MISC")
    makeBtn(CT, "3.3  CLOSE", Color3.fromRGB(100, 100, 100), function()
        setStep("3.3", "proses")
        V.enabled = false
        V.sessionOn = false
        V.destroyed = true
        if V.ScreenGui then V.ScreenGui:Destroy() end
        V.installed = false
    end)

    -- =========================================================
    -- TAB 4: STATUS DASHBOARD
    -- =========================================================
    local STAT = TabStatus
    makeSection(STAT, "═══ WORKFLOW STATUS ═══", Color3.fromRGB(150, 255, 150))

    local NextCard = Instance.new("Frame")
    NextCard.Size = UDim2.new(1, 0, 0, 60)
    NextCard.BackgroundColor3 = Color3.fromRGB(35, 40, 60)
    NextCard.BorderSizePixel = 0
    NextCard.Parent = STAT
    Instance.new("UICorner", NextCard).CornerRadius = UDim.new(0, 6)

    local NextTitle = Instance.new("TextLabel")
    NextTitle.Size = UDim2.new(1, -12, 0, 20)
    NextTitle.Position = UDim2.new(0, 8, 0, 6)
    NextTitle.BackgroundTransparency = 1
    NextTitle.Text = "NEXT ACTION"
    NextTitle.TextColor3 = Color3.fromRGB(150, 200, 255)
    NextTitle.Font = Enum.Font.GothamBold
    NextTitle.TextSize = 10
    NextTitle.TextXAlignment = Enum.TextXAlignment.Left
    NextTitle.Parent = NextCard
    V.NextTitle = NextTitle

    local NextBody = Instance.new("TextLabel")
    NextBody.Size = UDim2.new(1, -12, 0, 30)
    NextBody.Position = UDim2.new(0, 8, 0, 26)
    NextBody.BackgroundTransparency = 1
    NextBody.Text = "Klik 1.1 RUN STATIC SCAN"
    NextBody.TextColor3 = Color3.fromRGB(220, 220, 240)
    NextBody.Font = Enum.Font.Code
    NextBody.TextSize = 11
    NextBody.TextXAlignment = Enum.TextXAlignment.Left
    NextBody.TextWrapped = true
    NextBody.Parent = NextCard
    V.NextBody = NextBody

    makeSection(STAT, "STEPS", Color3.fromRGB(150, 255, 150))

    V.StepRows = {}
    local stepOrder = { "1.0", "1.1", "1.2", "1.3", "2.1", "2.2", "3.1", "3.2", "3.3" }

    for _, id in ipairs(stepOrder) do
        local info = V.steps[id]
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
        row.BorderSizePixel = 0
        row.Parent = STAT
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)

        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 24, 0, 32)
        icon.Position = UDim2.new(0, 4, 0, 0)
        icon.BackgroundTransparency = 1
        icon.Text = "○"
        icon.TextColor3 = Color3.fromRGB(150, 150, 160)
        icon.Font = Enum.Font.GothamBold
        icon.TextSize = 16
        icon.Parent = row

        local idLbl = Instance.new("TextLabel")
        idLbl.Size = UDim2.new(0, 40, 0, 16)
        idLbl.Position = UDim2.new(0, 30, 0, 2)
        idLbl.BackgroundTransparency = 1
        idLbl.Text = id
        idLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
        idLbl.Font = Enum.Font.GothamBold
        idLbl.TextSize = 10
        idLbl.TextXAlignment = Enum.TextXAlignment.Left
        idLbl.Parent = row

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -80, 0, 16)
        nameLbl.Position = UDim2.new(0, 70, 0, 2)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = info.label
        nameLbl.TextColor3 = Color3.fromRGB(220, 220, 235)
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = 10
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.Parent = row

        local stateLbl = Instance.new("TextLabel")
        stateLbl.Size = UDim2.new(1, -80, 0, 14)
        stateLbl.Position = UDim2.new(0, 70, 0, 16)
        stateLbl.BackgroundTransparency = 1
        stateLbl.Text = "BELUM" .. (info.note ~= "" and ("  (" .. info.note .. ")") or "")
        stateLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
        stateLbl.Font = Enum.Font.Code
        stateLbl.TextSize = 9
        stateLbl.TextXAlignment = Enum.TextXAlignment.Left
        stateLbl.Parent = row

        V.StepRows[id] = { icon = icon, state = stateLbl, row = row, name = nameLbl }
    end

    makeSection(STAT, "SUMMARY", Color3.fromRGB(150, 255, 150))
    local summaryLbl = makeInfoLabel(STAT,
        "Total: 0/9 selesai\nErrors: 0\nIn-progress: 0", 60)
    V.SummaryLbl = summaryLbl

    -- =========================================================
    -- BLOK F: DYNAMIC HOOK
    -- =========================================================
    local function safeFullName(inst)
        if typeof(inst) ~= "Instance" then return "?" end
        local ok, r = pcall(function() return inst:GetFullName() end)
        return ok and r or ("<" .. tostring(inst.Name) .. ">")
    end

    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if V.enabled and (method == "FireServer" or method == "InvokeServer") then
                local args = {...}
                if method == "InvokeServer" then
                    local result = oldNamecall(self, ...)
                    table.insert(V._rawNC, { self = self, method = method, args = args, result = result })
                    return result
                else
                    table.insert(V._rawNC, { self = self, method = method, args = args })
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)

    task.spawn(function()
        while not V.destroyed do
            task.wait(0.1)
            if #V._rawNC > 0 then
                local queue = V._rawNC
                V._rawNC = {}
                for _, item in ipairs(queue) do
                    pcall(function()
                        local name = safeFullName(item.self)
                        local stat = V.liveStats[name]
                        if not stat then
                            stat = { callCount = 0, fires = 0, invokes = 0, argCounts = {} }
                            V.liveStats[name] = stat
                        end
                        stat.callCount = stat.callCount + 1
                        if item.method == "InvokeServer" then stat.invokes = stat.invokes + 1
                        else stat.fires = stat.fires + 1 end
                        local ac = #item.args
                        stat.argCounts[ac] = (stat.argCounts[ac] or 0) + 1
                    end)
                end
            end
        end
    end)

    -- =========================================================
    -- BLOK J: STATUS UPDATE LOOP
    -- =========================================================
    local STATE_STYLES = {
        belum   = { icon = "○", color = Color3.fromRGB(150, 150, 160), text = "BELUM" },
        proses  = { icon = "◐", color = Color3.fromRGB(255, 200, 100), text = "PROSES..." },
        selesai = { icon = "●", color = Color3.fromRGB(120, 220, 120), text = "SELESAI" },
        error   = { icon = "✗", color = Color3.fromRGB(255, 100, 100), text = "ERROR" },
        skip    = { icon = "—", color = Color3.fromRGB(150, 150, 160), text = "SKIP" },
    }

    local function getNextAction()
        if V.steps["1.1"].state ~= "selesai" then
            if V.steps["1.1"].state == "proses" then
                return "Tunggu 1.1 (static scan) selesai..."
            elseif V.steps["1.1"].state == "error" then
                return "1.1 ERROR. Klik ulang 1.1 atau cek console."
            end
            return "Klik 1.1 RUN STATIC SCAN di tab 1.STATIC"
        end
        if V.steps["2.1"].state ~= "selesai" then
            if V.steps["2.1"].state == "proses" then
                return "Session RECORDING. Main normal lalu klik 2.2."
            end
            return "Klik 2.1 START SESSION di tab 2.DYNAMIC"
        end
        if V.steps["2.2"].state ~= "selesai" then
            return "Main game normal 3-5 menit, lalu klik 2.2 STOP SESSION"
        end
        if V.steps["3.1"].state ~= "selesai" then
            if V.steps["3.1"].state == "proses" then
                return "Tunggu 3.1 (cross-ref) selesai..."
            elseif V.steps["3.1"].state == "error" then
                return "3.1 ERROR. Cek: 1.1 done? 2.2 done?"
            end
            return "Klik 3.1 RUN CROSS-REF di tab 3.CROSS"
        end
        return "Semua step utama selesai. Klik 3.2 COPY CROSS REPORT."
    end

    task.spawn(function()
        while not V.destroyed do
            task.wait(0.5)

            local done, errors, proses = 0, 0, 0
            for id, row in pairs(V.StepRows) do
                local info = V.steps[id]
                local style = STATE_STYLES[info.state] or STATE_STYLES.belum

                row.icon.Text = style.icon
                row.icon.TextColor3 = style.color

                local label = style.text
                if info.note and info.note ~= "" and info.state ~= "belum" then
                    label = label .. " | " .. info.note
                elseif info.note and info.note ~= "" then
                    label = label .. "  (" .. info.note .. ")"
                end
                row.state.Text = label
                row.state.TextColor3 = style.color

                row.row.BackgroundColor3 = (info.state == "proses")
                    and Color3.fromRGB(50, 45, 30)
                    or Color3.fromRGB(28, 28, 38)

                if info.state == "selesai" then done = done + 1
                elseif info.state == "error" then errors = errors + 1
                elseif info.state == "proses" then proses = proses + 1 end
            end

            V.SummaryLbl.Text = string.format(
                "Total: %d/9 selesai\nErrors: %d | In-progress: %d",
                done, errors, proses
            )

            V.NextBody.Text = getNextAction()

            -- Static status detail
            local validC, failedC, placeholderC = 0, 0, 0
            for _, s in ipairs(V.staticScripts) do
                if s.parseOk then validC = validC + 1
                elseif not s.valid then placeholderC = placeholderC + 1
                else failedC = failedC + 1 end
            end
            V.StaticStatusLabel.Text = string.format(
                "Status: %s\nValid: %d | Failed: %d | Placeholder: %d\nTotal: %d | Findings: %d\nProgress: %d/%d\nCurrent: %s",
                V.staticState,
                validC, failedC, placeholderC,
                #V.staticScripts, #V.staticFindings,
                V.staticProgress.done, V.staticProgress.total,
                V.staticProgress.current ~= "" and V.staticProgress.current:sub(-35) or "-"
            )

            local rc, tc = 0, 0
            for _, s in pairs(V.liveStats) do rc = rc + 1; tc = tc + s.callCount end
            local dur = 0
            if V.sessionStartedAt > 0 and V.sessionStoppedAt > 0 then
                dur = math.floor(V.sessionStoppedAt - V.sessionStartedAt)
            elseif V.sessionStartedAt > 0 then
                dur = math.floor(tick() - V.sessionStartedAt)
            end
            V.DynamicStatusLabel.Text = string.format(
                "State: %s\nRemotes: %d | Calls: %d\nDuration: %ds",
                V.sessionState, rc, tc, dur
            )

            V.CrossStatusLabel.Text = string.format(
                "State: %s\nFindings: %d",
                V.crossState, #V.crossFindings,
            )
        end
    end)

    -- Logo minimize
    local Logo = Instance.new("TextButton")
    Logo.Size = UDim2.new(0, 50, 0, 50)
    Logo.Position = UDim2.new(0, 20, 0.5, -25)
    Logo.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Logo.Text = "V"
    Logo.TextColor3 = Color3.fromRGB(150, 130, 255)
    Logo.Font = Enum.Font.GothamBold
    Logo.TextSize = 22
    Logo.BorderSizePixel = 0
    Logo.Visible = false
    Logo.Active = true
    Logo.Parent = ScreenGui
    V.Logo = Logo
    Instance.new("UICorner", Logo).CornerRadius = UDim.new(1, 0)
    local ls = Instance.new("UIStroke", Logo)
    ls.Color = Color3.fromRGB(150, 130, 255)
    ls.Thickness = 2

    Logo.InputBegan:Connect(function(input)
        local ok = input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
        if not ok then return end
        local sIn, sPos = input.Position, Logo.Position
        local moved = false
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                if conn then conn:Disconnect() end
                if not moved then Main.Visible = true; Logo.Visible = false end
                return
            end
            local d = input.Position - sIn
            if d.Magnitude > 4 then moved = true end
            if moved then
                Logo.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
            end
        end)
    end)

    MinBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        Logo.Visible = true
    end)

    print("")
    print("==============================================")
    print(" VANZHUB STATIC ANALYZER v1.4 READY")
    print("==============================================")
    print("FIX: Placeholder detection")
    print("NEW: 1.0 DUMP SCRIPT SAMPLES")
    print("URUTAN PAKAI:")
    print("  TAB 1 - 1.1 RUN STATIC -> 1.0 DUMP (debug)")
    print("  TAB 2 - 2.1 START -> play -> 2.2 STOP")
    print("  TAB 3 - 3.1 RUN CROSS-REF")
    print("  TAB 4 - STATUS DASHBOARD")
    print("==============================================")
end
