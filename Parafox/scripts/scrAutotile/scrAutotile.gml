function updateWallIndexes(block)
{
	for(var i = 0; i < block.width; i++)
	{
		for(var j = 0; j < block.height; j++)
		{
			var wall = block.children[# i, j];
			if (instIsObject(wall, objWall))
			{
				wall.imageIndex = getWallImageIndex(getNeighborIndex(getWallNeighbors(block, i, j)));
			}
		}
	}
}

function getWallNeighbors(block, xx, yy)
{
	return new Neighbors(
		(yy == block.height-1) || instIsObject(block.children[# xx, yy+1], objWall),
		(xx == block.width-1) || (yy == block.height-1) || instIsObject(block.children[# xx+1, yy+1], objWall),
		(xx == block.width-1) || instIsObject(block.children[# xx+1, yy], objWall),
		(xx == block.width-1) || yy == 0 || instIsObject(block.children[# xx+1, yy-1], objWall),
		(yy == 0) || instIsObject(block.children[# xx, yy-1], objWall),
		(xx == 0) || yy == 0 || instIsObject(block.children[# xx-1, yy-1], objWall),
		(xx == 0) || instIsObject(block.children[# xx-1, yy], objWall),
		(xx == 0) || (yy == block.height-1) || instIsObject(block.children[# xx-1, yy+1], objWall)
	);
}

function Neighbors(_top, _topRight, _right, _bottomRight, _bottom, _bottomLeft, _left, _topLeft) constructor
{
	top = _top;
	right = _right;
	bottom = _bottom;
	left = _left;
	topRight = _topRight;
	bottomRight = _bottomRight;
	bottomLeft = _bottomLeft;
	topLeft = _topLeft;
}

function getNeighborIndex(neighbors)
{
	var edgeU = !neighbors.top;
	var edgeR = !neighbors.right;
	var edgeD = !neighbors.bottom;
	var edgeL = !neighbors.left;
	
	var cornerUR = !edgeU && !edgeR && !neighbors.topRight;
	var cornerDR = !edgeD && !edgeR && !neighbors.bottomRight;
	var cornerDL = !edgeD && !edgeL && !neighbors.bottomLeft;
	var cornerUL = !edgeU && !edgeL && !neighbors.topLeft;
	
	return 128 * edgeU + 64 * cornerUR + 32 * edgeR + 16 * cornerDR + 8 * edgeD + 4 * cornerDL + 2 * edgeL + 1 * cornerUL;
}

function getWallImageIndex(neighborIndex)
{
	switch(neighborIndex)
	{
		case 162: return 0;
		case 146: return 1;
		case 148: return 2;
		case 164: return 3;
		case 84: return 4;
		case 132: return 5;
		case 144: return 6;
		case 21: return 7;
		case 130: return 8;
		case 65: return 9;
		case 128: return 10;
		case 160: return 11;
		case 34: return 12;
		case 82: return 13;
		case 85: return 14;
		case 37: return 15;
		case 66: return 16;
		case 1: return 17;
		case 64: return 18;
		case 33: return 19;
		case 2: return 20;
		case 68: return 21;
		case 80: return 22;
		case 42: return 23;
		case 74: return 24;
		case 73: return 25;
		case 41: return 26;
		case 18: return 27;
		case 4: return 28;
		case 16: return 29;
		case 36: return 30;
		case 5: return 31;
		case 0: return 32;
		case 17: return 33;
		case 32: return 34;
		case 170: return 35;
		case 138: return 36;
		case 136: return 37;
		case 168: return 38;
		case 81: return 39;
		case 9: return 40;
		case 72: return 41;
		case 69: return 42;
		case 10: return 43;
		case 8: return 44;
		case 20: return 45;
		case 40: return 46;
		default: return 32;
	}
}