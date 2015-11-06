--数字滚动盘，使用两张图片滚动，却换图片

local vStart = 6000 --转动初始化速度

--计算图片位置与数字
function calculatePos( dt, imageTable) --imageTable保存两张图片的数据
	imageTable.tRolled = imageTable.tRolled - dt	--滚动时间
	local v = vStart
	--计算位置与图片显示的数字
	if( imageTable.pos1 >= 0 and imageTable.pos1 < imageTable.height) then	--第一阶段，第二张向上滚动，顶替第一张图片
		imageTable.pos1 = imageTable.pos1 + v*dt			--分别计算位置
		imageTable.pos2 = imageTable.pos1 - imageTable.height
		if( imageTable.num1Changed == true) then			--第一张图片却换后，第二张图片在视野外时，数字加2却换图片
			imageTable.num2 = imageTable.num2 + 2
			if( imageTable.num2 >= 10) then
				imageTable.num2 = 1
			end
			if( imageTable.tRolled <= 0 and imageTable.num1 == imageTable.mumLast) then  --到了滚动时间并与结果相同后停止转动
				imageTable.startRoll = false
				imageTable.pos1 = 0
				imageTable.pos2 = -imageTable.height
			end
			imageTable.num1Changed = false
		end
	elseif( imageTable.pos1 >= imageTable.height) then	--第二阶段，第二张完全占据屏幕，第一张图片在最上方，超出视野
		imageTable.pos1 = -imageTable.height		--第一张图片移动到最下方，
		imageTable.pos2 = 0
		imageTable.num1 = imageTable.num1 + 2		--没在视野内时，第一张图片数字加2
		if( imageTable.num1 >= 10) then
			imageTable.num1 = 0
		end
		if( imageTable.tRolled <= 0 and imageTable.num2 == imageTable.mumLast) then  --到了滚动时间并与结果相同后停止转动
			imageTable.startRoll = false
			imageTable.pos1 = -imageTable.height
			imageTable.pos2 = 0
		end
		imageTable.num1Changed = true
	else    	--第三阶段，第一张图片向上滚动，顶替第二张图片
		imageTable.pos1 = imageTable.pos1 + v*dt
		imageTable.pos2 = imageTable.pos1 + imageTable.height
	end

	local num1 = imageTable.num1
	local num2 = imageTable.num2
	if( num1 == 0) then
		num1 = 10
	end
	if( num2 == 0) then
		num2 = 10
	end

	--设置位置
	imageTable.numImage1.transform.localPosition = Vector3(0,imageTable.pos1,0)
	imageTable.numImage2.transform.localPosition = Vector3(0,imageTable.pos2,0)
	--设置图片
	imageTable.numImage1:GetComponent( "Image").sprite = GetIconSprite.GetSpriteByPath("UI/Atlas/CityTextures/CZJJ_Num" .. num1)
	imageTable.numImage2:GetComponent( "Image").sprite = GetIconSprite.GetSpriteByPath("UI/Atlas/CityTextures/CZJJ_Num" .. num2)
end

--滚动记时
function rollNumber( dt)
	for i=1,5 do
		if( numImageTable[i]~= nil and numImageTable[i].startRoll == true) then
			calculatePos( dt, numImageTable[i])
		end
	end
end

--初始化图片数据
function initNumImageTable( )
	local number = 109		--滚动结果的数字
	local mumberString = string.format( "%05d", number)
	
	numImageTable = {}
	local numPanel = ins_trans:FindChild("right/kxfp/kxfp/lhj")
	for i=1,5 do 
		local numImageData = {}
		numImageData.numImage1 = numPanel:FindChild( "num"..i.."/Image1")	--图片
		numImageData.numImage2 = numPanel:FindChild( "num"..i.."/Image2")
		numImageData.pos1 = numImageData.numImage1.localPosition.y		--位置
		numImageData.pos2 = numImageData.numImage2.localPosition.y
		numImageData.height = numImageData.numImage1.sizeDelta.y	--图片高度
		numImageData.num1 = 0  --图片显示的数字
		numImageData.num2 = 1
		numImageData.tRolled = 2+(5-i)*1  --转动的时间
		numImageData.num1Changed = false  --图片1是否却换图片
		numImageData.mumLast = tonumber(string.sub( mumberString, i, i))	--滚动结果要显示的数字
		numImageData.startRoll = true   --是否滚动

		numImageTable[i] = numImageData

	end
end