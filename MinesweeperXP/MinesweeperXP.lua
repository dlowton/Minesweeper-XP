--Minesweeper XP, created by Notviable.
--Version 0.1


--Global variables
local gameOver = false;
local textTiles = {};
local entryStatus = {};
local noOfRows = 0;
local noOfCols = 0;
local totalSeconds = 0;
local timer;
local gridSize = 81;
local markedBombs = 0;
local artPath = "Interface\\AddOns\\MinesweeperXP\\Art\\";
local firstClick = true;

Stack = {}
-- Create a Table with stack functions
function Stack:Create()

    -- stack table
    local t = {}
    -- entry table
    t._et = {}
  
    -- push a value on to the stack
    function t:push(...)
      if ... then
        local targs = {...}
        -- add values
        for _,v in ipairs(targs) do
          table.insert(self._et, v)
        end
      end
    end
  
    -- pop a value from the stack
    function t:pop(num)
  
      -- get num values from stack
      local num = num or 1
  
      -- return table
      local entries = {}
  
      -- get values into entries
      for i = 1, num do
        -- get last entry
        if #self._et ~= 0 then
          table.insert(entries, self._et[#self._et])
          -- remove last value
          table.remove(self._et)
        else
          break
        end
      end
      -- return unpacked entries
      return unpack(entries)
    end
  
    -- get entries
    function t:getn()
      return #self._et
    end
  
    -- list values
    function t:list()
      for i,v in pairs(self._et) do
        print(i, v)
      end
    end
    return t
  end

--Create main_frame and window texture
local main_frame = CreateFrame("frame", "MSXPFrame", UIParent);
main_frame:ClearAllPoints();
main_frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
main_frame:SetWidth(170);
main_frame:SetHeight(251);
main_frame:EnableMouse(true)
main_frame:SetMovable(true)
main_frame:RegisterForDrag("LeftButton")
main_frame:SetScript("OnMouseDown", main_frame.StartMoving)
main_frame:SetScript("OnMouseUp", main_frame.StopMovingOrSizing)
main_frame:Hide();


--Create window texture
main_frame.window = main_frame:CreateTexture("xpwindow","BACKGROUND");
main_frame.window:SetDrawLayer("BACKGROUND",1);
main_frame.window:SetWidth(170);
main_frame.window:SetHeight(251);
main_frame.window:SetPoint("TOPLEFT", main_frame, "TOPLEFT",0,0);
main_frame.window:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\ms_standard.tga");
main_frame.window:SetTexCoord(0,339/512,0,500/512);

--Create Exit button, 16x14px (16x16px native)
main_frame.exitButton = CreateFrame("Button","exitbutton",main_frame);
main_frame.exitButton:SetPoint("TOPRIGHT", main_frame,"TOPRIGHT",-5,-5);
main_frame.exitButton:SetSize(16,14);
main_frame.exitButton:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\Exit_Normal.blp");
main_frame.exitButton:GetNormalTexture():SetTexCoord(0,1,0,14/16);
main_frame.exitButton:SetPushedTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\Exit_Pushed.blp");
main_frame.exitButton:GetPushedTexture():SetTexCoord(0,1,0,14/16);
main_frame.exitButton:SetScript("OnClick", function(self) 
    main_frame:Hide();
end)

--Create minimise button, 16x14px (16x16px native)
main_frame.minButton = CreateFrame("Button","minbutton",main_frame);
main_frame.minButton:SetPoint("TOPRIGHT", main_frame,"TOPRIGHT",-39,-5);
main_frame.minButton:SetSize(16,14);
main_frame.minButton:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\Min_Normal.blp");
main_frame.minButton:GetNormalTexture():SetTexCoord(0,1,0,14/16);
main_frame.minButton:SetPushedTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\Min_Pushed.blp");
main_frame.minButton:GetPushedTexture():SetTexCoord(0,1,0,14/16);
main_frame.minButton:SetScript("OnClick", function(self) 
    main_frame:Hide();
end)

--Create bomb count number textures 1
main_frame.bombCountTex1 = main_frame:CreateTexture("bctexture1","ARTWORK");
main_frame.bombCountTex1:SetDrawLayer("ARTWORK",2);
main_frame.bombCountTex1:SetSize(13,23);
main_frame.bombCountTex1:SetPoint("TOPLEFT",main_frame,"TOPLEFT",20,-57);
main_frame.bombCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
main_frame.bombCountTex1:SetTexCoord(0,13/32,0,23/32);

--Create bomb count number textures 2
main_frame.bombCountTex2 = main_frame:CreateTexture("bctexture2","ARTWORK");
main_frame.bombCountTex2:SetDrawLayer("ARTWORK",2);
main_frame.bombCountTex2:SetSize(13,23);
main_frame.bombCountTex2:SetPoint("TOPLEFT",main_frame.bombCountTex1,"TOPRIGHT",0,0);
main_frame.bombCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
main_frame.bombCountTex2:SetTexCoord(0,13/32,0,23/32);

--Create bomb count number textures 3
main_frame.bombCountTex3 = main_frame:CreateTexture("bctexture3","ARTWORK");
main_frame.bombCountTex3:SetDrawLayer("ARTWORK",2);
main_frame.bombCountTex3:SetSize(13,23);
main_frame.bombCountTex3:SetPoint("TOPLEFT",main_frame.bombCountTex2,"TOPRIGHT",0,0);
main_frame.bombCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
main_frame.bombCountTex3:SetTexCoord(0,13/32,0,23/32);

if gridSize == 81 then
    main_frame.bombCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\1Number.blp");
end

--Create timer count number textures 1
main_frame.timerCountTex1 = main_frame:CreateTexture("timertexture1","ARTWORK");
main_frame.timerCountTex1:SetDrawLayer("ARTWORK",2);
main_frame.timerCountTex1:SetSize(13,23);
main_frame.timerCountTex1:SetPoint("TOPLEFT",main_frame,"TOPLEFT",113,-57);
main_frame.timerCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
main_frame.timerCountTex1:SetTexCoord(0,13/32,0,23/32);

--Create timer count number textures 2
main_frame.timerCountTex2 = main_frame:CreateTexture("timertexture2","ARTWORK");
main_frame.timerCountTex2:SetDrawLayer("ARTWORK",2);
main_frame.timerCountTex2:SetSize(13,23);
main_frame.timerCountTex2:SetPoint("TOPLEFT",main_frame.timerCountTex1,"TOPRIGHT",0,0);
main_frame.timerCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
main_frame.timerCountTex2:SetTexCoord(0,13/32,0,23/32);

--Create timer count number textures 3
main_frame.timerCountTex3 = main_frame:CreateTexture("timertexture3","ARTWORK");
main_frame.timerCountTex3:SetDrawLayer("ARTWORK",2);
main_frame.timerCountTex3:SetSize(13,23);
main_frame.timerCountTex3:SetPoint("TOPLEFT",main_frame.timerCountTex2,"TOPRIGHT",0,0);
main_frame.timerCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
main_frame.timerCountTex3:SetTexCoord(0,13/32,0,23/32);



--Create tile buttons & underlying textures
for i=1,81 do 
    --Buttons
	main_frame["tileButton"..i] = CreateFrame("BUTTON","tilebutton"..i,main_frame);
	main_frame["tileButton"..i]:SetSize(16,16);
    main_frame["tileButton"..i]:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock.blp");
    main_frame["tileButton"..i]:GetNormalTexture():SetTexCoord(0,14/16,0,14/16);
    main_frame["tileButton"..i]:SetPushedTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
    main_frame["tileButton"..i]:GetPushedTexture():SetTexCoord(0,14/16,0,14/16);
    --main_frame["tileButton"..i]:Hide();

    --Textures
    main_frame["tileTexture"..i] = main_frame:CreateTexture("tiletexture"..i,"ARTWORK");
    main_frame["tileTexture"..i]:SetDrawLayer("ARTWORK",2);
    main_frame["tileTexture"..i]:SetSize(16,16);
    main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
    main_frame["tileTexture"..i]:SetTexCoord(0,14/16,0,14/16);
    
end





--Stitching algorithm
noOfRows = 9;
noOfCols = 9;
local baseIncrementer = 0;

for x=1,noOfRows do --Cycle rows
	for j=1,noOfCols do --Cycle columns
		--If we're addressing the first tile placed
		if (j+baseIncrementer) == 1 then
            main_frame["tileButton"..(j+baseIncrementer)]:SetPoint("TOPLEFT", main_frame,"TOPLEFT", 15,-96);
            main_frame["tileTexture"..(j+baseIncrementer)]:SetPoint("TOPLEFT", main_frame,"TOPLEFT", 15,-96);
		end

		--If we're addressing the first tile of a new row
		if j == 1 and (x+baseIncrementer) ~= 1 then
            main_frame["tileButton"..(j+baseIncrementer)]:SetPoint("TOPLEFT", main_frame["tileButton"..((baseIncrementer-(noOfCols-1)))],"BOTTOMLEFT")
            main_frame["tileTexture"..(j+baseIncrementer)]:SetPoint("TOPLEFT", main_frame["tileTexture"..((baseIncrementer-(noOfCols-1)))],"BOTTOMLEFT")
		--If we're addressing any other tile
		elseif (j+baseIncrementer) ~= 1 then
            main_frame["tileButton"..(j+baseIncrementer)]:SetPoint("TOPLEFT", main_frame["tileButton"..((j+baseIncrementer)-1)],"TOPRIGHT")
            main_frame["tileTexture"..(j+baseIncrementer)]:SetPoint("TOPLEFT", main_frame["tileTexture"..((j+baseIncrementer)-1)],"TOPRIGHT")
		end
	end

	--Increment to address the correct rows tiles
	if baseIncrementer ~= (noOfCols*noOfRows) then 
		baseIncrementer = baseIncrementer + noOfCols 
	end
end

--Create array of tile texture numbers and entry status
--entryStatus[i][j] = {Bomb?(0/1),Number?(0-8),Unhide?(0/1),Visited?(0/1)}
local inc2 = 0;
for i=1,noOfCols do
    textTiles[i] = {}
    entryStatus[i] = {}
    for j=1,noOfRows do
        textTiles[i][j] = j+inc2;
        entryStatus[i][j] = {0,0,0,0}
    end
    if inc2 ~= (noOfCols*noOfRows) then
        inc2 = inc2 + noOfCols;
    end
end

--Update entry status
--entryStatus[i][j] = {Bomb?(0/1),Number?(0-8),Unhide?(0/1),Visited?(0/1)}
function updateStatus()
    for i=1,noOfCols do
        for j=1,noOfRows do
            if main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                entryStatus[i][j][1] = 1;
                entryStatus[i][j][2] = 0;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."oneblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 1;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."twoblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 2;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."threeblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 3;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."fourblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 4;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."fiveblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 5;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."sixblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 6;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."sevenblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 7;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            elseif main_frame["tileTexture"..textTiles[i][j]]:GetTexture() == artPath.."eightblock" then
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 8;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            else
                entryStatus[i][j][1] = 0;
                entryStatus[i][j][2] = 0;
                entryStatus[i][j][3] = 0;
                entryStatus[i][j][4] = 0;
            end
        end
        if inc2 ~= (noOfCols*noOfRows) then
            inc2 = inc2 + noOfCols;
        end
    end
end

function showSquares()
    for i=1,noOfCols do
        for j=1,noOfRows do
            if entryStatus[i][j][3] == 1 and entryStatus[i][j][1] == 0 then main_frame["tileButton"..textTiles[i][j]]:Hide(); end
        end
    end
end

--Randomise where bombs are
function genBombs(noOfBombs, i)
    local position = 0;
    local okay = false;
    local bombcount = 0;

    while okay == false do
        position = math.random(1,81);
        --Check whether position already has a bomb on it and if not set as a bomb
        if main_frame["tileTexture"..position]:GetTexture() ~= "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown.blp" and position ~= i then
            main_frame["tileTexture"..position]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown.blp");
            bombcount = bombcount + 1;
        end

        --Check whether bombcount = noOfBombs
        if bombcount == noOfBombs then
            okay = true
        end
    end
end

function genNumBlocks()
    for i=1,noOfCols do
        for j=1,noOfRows do
            local surroundingBombs = 0;

            if main_frame["tileTexture"..textTiles[i][j]]:GetTexture() ~= "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                --Check top left
                if i - 1 >= 1 and j - 1 >= 1 then
                    if main_frame["tileTexture"..textTiles[i-1][j-1]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check absolute left
                if i - 1 >= 1 then
                    if main_frame["tileTexture"..textTiles[i-1][j]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check bottom left
                if i - 1 >= 1 and j + 1 <= 9 then
                    if main_frame["tileTexture"..textTiles[i-1][j+1]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check top right
                if i + 1 <= 9 and j - 1 >= 1 then
                    if main_frame["tileTexture"..textTiles[i+1][j-1]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check absolute right
                if i + 1 <= 9 then
                    if main_frame["tileTexture"..textTiles[i+1][j]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check bottom right
                if i + 1 <= 9 and j + 1 <= 9 then
                    if main_frame["tileTexture"..textTiles[i+1][j+1]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check top
                if j - 1 >= 1 then
                    if main_frame["tileTexture"..textTiles[i][j-1]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                --Check bottom
                if j + 1 <= 9 then
                    if main_frame["tileTexture"..textTiles[i][j+1]]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        surroundingBombs = surroundingBombs + 1;
                    end
                end

                if surroundingBombs ~= 0 then
                    main_frame["tileTexture"..textTiles[i][j]]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..surroundingBombs.."block.blp");
                else
                    main_frame["tileTexture"..textTiles[i][j]]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
                end
            end
        end
    end
    updateStatus();
end

--Create reset button, 24x24px
main_frame.resetButton = CreateFrame("Button","resetbutton",main_frame);
main_frame.resetButton:SetPoint("TOPLEFT", main_frame,"TOPLEFT",75,-57);
main_frame.resetButton:SetSize(24,24);
main_frame.resetButton:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\happyface_normal.blp");
main_frame.resetButton:GetNormalTexture():SetTexCoord(0,24/32,0,24/32);
main_frame.resetButton:SetPushedTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\happyface_pushed.blp");
main_frame.resetButton:GetPushedTexture():SetTexCoord(0,24/32,0,24/32);
main_frame.resetButton:SetScript("OnClick", function(self) 
    firstClick = true;
    for i=1,gridSize do
        if main_frame["tileButton"..i]:IsShown() == false then
            main_frame["tileButton"..i]:Show()
        end
    end
    for i=1,gridSize do
        main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
    end
    totalSeconds = 0;
    if timer ~= nil then timer:Cancel(); end
    timer = C_Timer.NewTicker(1,function() 
        if totalSeconds < 999 then
            totalSeconds = totalSeconds + 1;
            main_frame.timerCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor((totalSeconds/100)%10).."Number.blp");
            main_frame.timerCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor((totalSeconds/10)%10).."Number.blp");
            main_frame.timerCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor(totalSeconds%10).."Number.blp");
        end
    end);
end)

function floodFillStack(i,j)
    stack = Stack:Create();
    if entryStatus[i][j][1] == 1 then 
        return;
    elseif entryStatus[i][j][2] > 0 then
        return;
    else
        entryStatus[i][j][3] = 1;
        stack:push({i,j});
        while stack:getn() ~= 0 do
            print(stack:getn());
            local temp = stack:pop(1);
            local y,u = temp[1],temp[2];

            if y - 1 >= 1 then 
                if entryStatus[y-1][u][1] == 0 and entryStatus[y-1][u][4] ~= 1 then
                    entryStatus[y-1][u][3] = 1;
                    entryStatus[y-1][u][4] = 1;
                    if entryStatus[y-1][u][2] == 0 then
                        stack:push({y-1,u});
                    end
                    
                end
            end

            if y - 1 >= 1 and u - 1 >= 1 then 
                if entryStatus[y-1][u-1][1] == 0 and entryStatus[y-1][u-1][4] ~= 1 then
                    entryStatus[y-1][u-1][3] = 1;
                    entryStatus[y-1][u-1][4] = 1;
                    if entryStatus[y-1][u-1][2] == 0 then
                        stack:push({y-1,u-1});
                    end
                    
                end
            end

            if y - 1 >= 1 and u + 1 <= 9 then 
                if entryStatus[y-1][u+1][1] == 0 and entryStatus[y-1][u+1][4] ~= 1 then
                    entryStatus[y-1][u+1][3] = 1;
                    entryStatus[y-1][u+1][4] = 1;
                    if entryStatus[y-1][u+1][2] == 0 then
                        stack:push({y-1,u+1});
                    end
                    
                end
            end

            if y + 1 <= 9 then 
                if entryStatus[y+1][u][1] == 0 and entryStatus[y+1][u][4] ~= 1  then
                    entryStatus[y+1][u][3] = 1;
                    entryStatus[y+1][u][4] = 1;
                    if entryStatus[y+1][u][2] == 0 then
                        stack:push({y+1,u});
                    end
                    
                end
            end

            if y + 1 <= 9 and u -1 >= 1 then 
                if entryStatus[y+1][u-1][1] == 0 and entryStatus[y+1][u-1][4] ~= 1  then
                    entryStatus[y+1][u-1][3] = 1;
                    entryStatus[y+1][u-1][4] = 1;
                    if entryStatus[y+1][u-1][2] == 0 then
                        stack:push({y+1,u-1});
                    end
                    
                end
            end

            if y + 1 <= 9 and u +1 <= 9 then 
                if entryStatus[y+1][u+1][1] == 0 and entryStatus[y+1][u+1][4] ~= 1  then
                    entryStatus[y+1][u+1][3] = 1;
                    entryStatus[y+1][u+1][4] = 1;
                    if entryStatus[y+1][u+1][2] == 0 then
                        stack:push({y+1,u+1});
                    end
                    
                end
            end

            if u - 1 >= 1 then 
                if entryStatus[y][u-1][1] == 0 and entryStatus[y][u-1][4] ~= 1 then
                    entryStatus[y][u-1][3] = 1;
                    entryStatus[y][u-1][4] = 1;
                    if entryStatus[y][u-1][2] == 0 then
                        stack:push({y,u-1});
                    end
                    
                end
                
            end

            if u + 1 <= 9 then 
                if entryStatus[y][u+1][1] == 0 and entryStatus[y][u+1][4] ~= 1 then
                    entryStatus[y][u+1][3] = 1;
                    entryStatus[y][u+1][4] = 1;
                    if entryStatus[y][u+1][2] == 0 then
                        stack:push({y,u+1});
                    end
                    
                end
            end

            
        end
    end

end

for i=1,gridSize do
    main_frame["tileButton"..i]:SetScript("OnClick", function(self, button)
        if button == "LeftButton" then
            if firstClick == true then
                genBombs(10, i);
                genNumBlocks();
            end
            firstClick = false;
            if main_frame["tileTexture"..i]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                
                main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_hit.blp")
                for j=1,gridSize do
                    --If user incorrectly flagged a block as a bomb
                    if main_frame["tileButton"..j]:IsShown() == true 
                    and main_frame["tileButton"..j]:GetNormalTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\flaggedblock"  
                    and main_frame["tileTexture"..j]:GetTexture() ~= "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                        main_frame["tileTexture"..j]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_cross.blp");
                    end
                    main_frame["tileButton"..j]:Hide();
                end
                timer:Stop();
                main_frame.resetButton:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\sadface.blp");
            else
                --Else do floodfill
                --Find i,j value that corresponds to i of this loop
                local l,j = 0,0;
                for x=1,9 do
                    for p=1,9 do
                        if textTiles[x][p] == i then 
                            l = x;
                            j = p;
                        end
                    end
                end
                
                print(l.."+"..j)
                floodFillStack(l,j);
                showSquares();
            end
            
        elseif button == "RightButton" then
            main_frame["tileButton"..i]:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\flaggedblock.blp");
        end 
        
    end);
end


--Create slash command
SLASH_MS1 = '/minesweeper'; 
SLASH_MS2 = '/msxp';
function SlashCmdList.MS(msg, editbox)
    if main_frame:IsShown() == true then
        if timer ~= nil then timer:Cancel(); end
        main_frame:Hide();
    else
        main_frame:Show();
        for i=1,gridSize do
            if main_frame["tileButton"..i]:IsShown() == false then
                main_frame["tileButton"..i]:Show()
            end
        end
        for i=1,gridSize do
            main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
        end
        totalSeconds = 0;
        if timer ~= nil then timer:Cancel(); end
        timer = C_Timer.NewTicker(1,function() 
            if totalSeconds < 999 then
                totalSeconds = totalSeconds + 1;
                main_frame.timerCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor((totalSeconds/100)%10).."Number.blp");
                main_frame.timerCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor((totalSeconds/10)%10).."Number.blp");
                main_frame.timerCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor(totalSeconds%10).."Number.blp");
            end
        end);
    end
end


