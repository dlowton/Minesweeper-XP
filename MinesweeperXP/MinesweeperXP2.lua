--Minesweeper XP, created by Notviable.
--Version 0.1

--SavedVariables
local savedGridS;


--Global variables
local gridSize = 81;
local totalSeconds = 0;
local timer;
local markedBombs = 0;
local artPath = "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\";
local firstClick = true;
local rows = 0;
local cols = 0;
local noOfBombs = 0;
local fBlockCount = 0;
local entryStatus = {};

--Setup for a grid size of 81.
if gridSize == 81 then
    cols = math.sqrt(gridSize);
    rows = math.sqrt(gridSize);
    noOfBombs = 10;
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

function updateBombCount()
  local showNum = noOfBombs - fBlockCount;
  main_frame.bombCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor((showNum/100)%10).."Number.blp");
  main_frame.bombCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor((showNum/10)%10).."Number.blp");
  main_frame.bombCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..floor(showNum%10).."Number.blp");
end

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
for i=1,gridSize do 
    --Buttons
    main_frame["tileButton"..i] = CreateFrame("BUTTON","tilebutton"..i,main_frame);
    main_frame["tileButton"..i]:SetFrameStrata("HIGH");
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

--Create array of tile texture numbers and entry status
--entryStatus[i][j] = {Bomb?(0/1),Number?(0-8),Unhide?(0/1),Visited?(0/1)}
for x=1,rows do
  for y=1,cols do
    local index4 = ((x-1)*rows)+y
    entryStatus[index4] = {0,0,0,0}
  end
end

function updateStatus()
  for x=1,rows do
    for y=1,cols do
      local index3 = ((x-1)*rows)+y
      if main_frame["tileTexture"..index3]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
        entryStatus[index3][1] = 1;
        entryStatus[index3][2] = 0;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."1block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 1;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."2block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 2;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."3block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 3;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."4block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 4;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."5block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 5;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."6block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 6;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."7block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 7;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      elseif main_frame["tileTexture"..index3]:GetTexture() == artPath.."8block" then
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 8;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      else
        entryStatus[index3][1] = 0;
        entryStatus[index3][2] = 0;
        entryStatus[index3][3] = 0;
        entryStatus[index3][4] = 0;
      end
    end
  end
end


function showSquares()
  for x=1,rows do
    for y=1,cols do
      local index2 = ((x-1)*rows)+y
      if entryStatus[index2][3] == 1 and entryStatus[index][1] == 0 then 
        main_frame["tileButton"..index2]:Hide(); 
      end
    end
  end
end

--Generate bombs
function genBombs(noOfBombs, clickedPos)
  local position = 0;
  local done = false; --Change this.
  local bcount = 0; --Number of bombs placed by function.

  --Loop until all bombs are placed.
  while done == false do
    position = math.random(1,gridSize);
    --Check if a position already has a bomb on it.
    if main_frame["tileTexture"..position]:GetTexture() ~= "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown.blp" and position ~= clickedPos then
      main_frame["tileTexture"..position]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown.blp");
      bcount = bcount + 1;
    end

    --Check whether to terminate loop.
    if bcount == noOfBombs then
      done = true;
    end
  end
end

--Generate numerical tiles
function genNumberBlocks()
  --Iterate over as a 2D array
  for x=1,rows do
    for y=1,cols do
      local surroundingBombs = 0;
      index = ((x-1)*rows)+y

      --If the tile we're on is not a bomb.
      if main_frame["tileTexture"..index]:GetTexture() ~= "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
        
        --Check topleft
        if x - 1 >= 1 and y - 1 >= 1 then
          localindex = ((x-2)*rows)+(y-1)
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check absolute left
        if x - 1 >= 1 then
          localindex = ((x-2)*rows)+y
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check bottom left
        if x - 1 >= 1 and y + 1 <= 9 then
          localindex = ((x-2)*rows)+(y+1)
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check top right
        if x + 1 <= 9 and y - 1 >= 1 then
          localindex = ((x)*rows)+(y-1)
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check absolute right
        if x + 1 <= 9 then
          localindex = ((x)*rows)+y
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check bottom right
        if x + 1 <= 9 and y + 1 <= 9 then
          localindex = ((x)*rows)+(y+1)
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check top
        if y - 1 >= 1 then
          localindex = ((x-1)*rows)+(y-1)
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        --Check bottom
        if y + 1 <= 9 then
          localindex = ((x-1)*rows)+(y+1)
          if main_frame["tileTexture"..localindex]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
            surroundingBombs = surroundingBombs + 1;
          end
        end

        if surroundingBombs ~= 0 then
          main_frame["tileTexture"..index]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\"..surroundingBombs.."block.blp");
        else
          main_frame["tileTexture"..index]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock_pushed.blp");
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
  main_frame.timerCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
  main_frame.timerCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
  main_frame.timerCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
  firstClick = true;
  fBlockCount = 0;
  updateBombCount();
  --Show all tile buttons again
  for i=1,gridSize do
    main_frame["tileButton"..i]:Show();
    main_frame["tileButton"..i]:Hide();
    main_frame["tileButton"..i]:Show();
    main_frame["tileButton"..i]:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock.blp");
    --Reset the grid.
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


end);

function floodfillStack(x,y)
  stack = Stack:Create();
  local ffindex = ((x-1)*rows)+y;
  --If user hit a bomb
  if entryStatus[ffindex][1] == 1 then
    return;
  --If a number block is clicked.
  elseif entryStatus[ffindex][2] > 0 then
    entryStatus[ffindex][3] = 1; --unhide the block
    return;
  --Do the regular floodfill
  else
    --Set visited to 1/true
    entryStatus[ffindex][3] = 1;
    --Push the location onto the stack.
    stack:push({x,y});

    --Do the floodfill whilst the stack isnt empty.
    while stack:getn() ~= 0 do
      --Pop the first item off.
      local temp = stack:pop(1);
      local tx,ty = temp[1],temp[2]; --Temporary x,y coords.

      --Check left.
      if tx - 1 >= 1 then
        local tindex = ((tx-2)*rows)+ty
        --If the square to the left is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the left is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx-1,ty});
          end
        end
      end
      
      --Check topleft
      if tx - 1 >= 1 and ty - 1 >= 1 then
        local tindex = ((tx-2)*rows)+(ty-1)
        --If the square to the topleft is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the topleft is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx-1,ty-1});
          end
        end
      end

      --Check right.
      if tx + 1 <= 9 then
        local tindex = ((tx)*rows)+ty
        --If the square to the right is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the right is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx+1,ty});
          end
        end
      end

      --Check topright
      if tx + 1 <= 9 and ty - 1 >= 1 then
        local tindex = ((tx)*rows)+(ty-1)
        --If the square to the topright is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the topright is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx+1,ty-1});
          end
        end
      end

      --Check bottomright
      if tx + 1 <= 9 and ty + 1 <= 9 then
        local tindex = ((tx)*rows)+(ty+1)
        --If the square to the bottomright is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the bottomright is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx+1,ty+1});
          end
        end
      end

      --Check up.
      if ty - 1 >= 1 then
        local tindex = ((tx-1)*rows)+(ty-1)
        --If the square to the up is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the up is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx,ty-1});
          end
        end
      end

      --Check down.
      if ty + 1 <= 9 then
        local tindex = ((tx-1)*rows)+(ty+1)
        --If the square to the up is not a bomb and we havent visited
        if entryStatus[tindex][1] == 0 and entryStatus[tindex][4] ~= 1 then
          entryStatus[tindex][3] = 1; --unhide the block
          entryStatus[tindex][4] = 1; --we've visited.
          --If the square to the up is a lone block, push.
          if entryStatus[tindex][2] == 0 then
            stack:push({tx,ty+1});
          end
        end
      end




    end
  end

end

--Check whether game is over.
function checkGameOver()
  local shownBlocks = 0;
  --Find the number of blocks shown
  for i=1,gridSize do
    if main_frame["tileButton"..i]:IsShown() == true then
      shownBlocks = shownBlocks + 1;
    end
  end

  if shownBlocks == fBlockCount then
    --Game over functionality
    timer:Cancel(); --stop the timer
    --GET SHADES ICON
  end


end

--Stitching algorithm and function setting
for x=1,rows do
  for y=1,cols do
        --interate through 1D array as 2D array
        local index = ((x-1)*rows)+y

        --Attach first button and tile texture.
        if index == 1 then
            main_frame["tileButton"..index]:SetPoint("TOPLEFT", main_frame,"TOPLEFT", 15,-96);
            main_frame["tileTexture"..index]:SetPoint("TOPLEFT", main_frame,"TOPLEFT", 15,-96);
            first = true;
        end
        --First tile of each new row
        if x ~= 1 and y == 1 then
            main_frame["tileButton"..index]:SetPoint("TOPLEFT", main_frame["tileButton"..(index-rows)],"BOTTOMLEFT")
            main_frame["tileTexture"..index]:SetPoint("TOPLEFT", main_frame["tileTexture"..(index-rows)],"BOTTOMLEFT")
        elseif index ~= 1 then
            main_frame["tileButton"..index]:SetPoint("TOPLEFT", main_frame["tileButton"..(index-1)],"TOPRIGHT")
            main_frame["tileTexture"..index]:SetPoint("TOPLEFT", main_frame["tileTexture"..(index-1)],"TOPRIGHT")
        end

        --Script button
        main_frame["tileButton"..index]:SetScript("OnMouseDown", function(self, button)
          --If a standard left click.
          if button == "LeftButton" then

            --Check for first click
            --Generate bombs and number blocks.
            if firstClick == true then
              genBombs(noOfBombs, index);
              genNumberBlocks();
            end

            firstClick = false; --Set first click back to false.

            --If user hits a bomb.
            if main_frame["tileTexture"..index]:GetTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
              --Set the corresponding texture tile to bomb hit.
              main_frame["tileTexture"..index]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_hit.blp")
              for i=1,gridSize do

                --If user incorrectly flagged a block as a bomb
                if main_frame["tileButton"..i]:IsShown() == true 
                and main_frame["tileButton"..i]:GetNormalTexture() == "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\flaggedblock"  
                and main_frame["tileTexture"..i]:GetTexture() ~= "Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_shown" then
                    main_frame["tileTexture"..i]:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\bomb_cross.blp");
                end

                main_frame["tileButton"..i]:Hide();
              end

            --If user didn't hit a bomb, floodfill algorithm.
            else
              --Call the floodfill with x,y coords.
              updateStatus();
              floodfillStack(x,y);
              showSquares();
              checkGameOver();
            end

          elseif button == "RightButton" then

            --First check unflags the block
            if main_frame["tileButton"..index]:GetNormalTexture():GetTexture() == artPath.."flaggedblock" then
              main_frame["tileButton"..index]:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\plainblock.blp");
              fBlockCount = fBlockCount - 1;
              updateBombCount();
            --Else flags the block
            else
              main_frame["tileButton"..index]:SetNormalTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\flaggedblock.blp");
              --Increase flagged block count
              fBlockCount = fBlockCount + 1;
              updateBombCount();
            end
          end

        end);

      

    end
end




--Create slash command
SLASH_MS1 = '/minesweeper'; 
SLASH_MS2 = '/msxp';
function SlashCmdList.MS(msg, editbox)
    if main_frame:IsShown() == true then
        main_frame.timerCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
        main_frame.timerCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
        main_frame.timerCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
        if timer ~= nil then timer:Cancel(); end
        totalSeconds = 0;
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

        --Reset timer.
        main_frame.timerCountTex1:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
        main_frame.timerCountTex2:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
        main_frame.timerCountTex3:SetTexture("Interface\\AddOns\\MinesweeperXP\\Art\\blp\\0Number.blp");
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