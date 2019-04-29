--Minesweeper XP, created by Notviable.
--Version 0.1

--SavedVariables
local savedGridS;


--Global variables
local gridSize = 81;
local totalSeconds = 0;
local timer;
local markedBombs = 0;
local artPath = "Interface\\AddOns\\MinesweeperXP\\Art\\";
local firstClick = true;
local noOfRows = 0;
local noOfCols = 0;

--Get rows and columns
if gridSize == 81 then
    noOfCols = math.sqrt(gridSize);
    noOfRows = math.sqrt(gridSize);
end

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

--set the bomb count text to '10'
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
for i=0,gridSize-1 do 
    --Buttons
	main_frame["tileButton"..i] = CreateFrame("BUTTON","tilebutton"..i,main_frame);
	main_frame["tileButton"..i]:SetSize(16,16);
    main_frame["tileButton"..i]:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock.blp");
    main_frame["tileButton"..i]:GetNormalTexture():SetTexCoord(0,14/16,0,14/16);
    main_frame["tileButton"..i]:SetPushedTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
    main_frame["tileButton"..i]:GetPushedTexture():SetTexCoord(0,14/16,0,14/16);

    --Textures
    main_frame["tileTexture"..i] = main_frame:CreateTexture("tiletexture"..i,"ARTWORK");
    main_frame["tileTexture"..i]:SetDrawLayer("ARTWORK",2);
    main_frame["tileTexture"..i]:SetSize(16,16);
    main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
    main_frame["tileTexture"..i]:SetTexCoord(0,14/16,0,14/16);
    
end

--Stitching algorithm
for x=0,noOfCols-1 do
    for y=0,noOfRows-1 do
        --interate through 1D array as 2D array
        index = (y) + ((x)*noOfCols)

        if index == 0 then
            main_frame["tileButton"..index]:SetPoint("TOPLEFT", main_frame,"TOPLEFT", 15,-96);
            main_frame["tileTexture"..index]:SetPoint("TOPLEFT", main_frame,"TOPLEFT", 15,-96);
        end

        --First tile of each new row
        if x ~= 0 and y == 0 then
            main_frame["tileButton"..index]:SetPoint("TOPLEFT", main_frame["tileButton"..(index-noOfRows)],"BOTTOMLEFT")
            main_frame["tileTexture"..index]:SetPoint("TOPLEFT", main_frame["tileTexture"..(index-noOfRows)],"BOTTOMLEFT")
        else
            main_frame["tileButton"..index]:SetPoint("TOPLEFT", main_frame["tileButton"..(index-1)],"TOPRIGHT")
            main_frame["tileTexture"..index]:SetPoint("TOPLEFT", main_frame["tileTexture"..(index-1)],"TOPRIGHT")
        end

    end
end


--Create slash command
SLASH_MS1 = '/minesweeper'; 
SLASH_MS2 = '/msxp';
function SlashCmdList.MS(msg, editbox)
    if main_frame:IsShown() == true then
        main_frame:Hide();
    else
        main_frame:Show();
        for i=0,gridSize-1 do
            if main_frame["tileButton"..i]:IsShown() == false then
                main_frame["tileButton"..i]:Show()
            end
        end
        for i=0,gridSize-1 do
            main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
        end
    end
end