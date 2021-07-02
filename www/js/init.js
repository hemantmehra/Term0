/*
	term 0
		 size  =  40 * 25
	pixel size = 640 * 400
	cell size  =  16 * 16
*/

var canvas = document.getElementById('term');
var ctx = canvas.getContext('2d');
var canvasWidth = canvas.width;
var canvasHeight = canvas.height;
var scale = 1;
var charWidth = scale * 8;
var charHeight = scale * 8;
// ---- Term Unit ----
var columns = 64;
var rows = 43;
var posX = 1;
var posY = 1;

var mem = [];

function clearScreen() {
	ctx.clearRect(0, 0, canvasWidth, canvasHeight);
}

function _drawCharXY(c, x, y) {
	var id = ctx.getImageData(0, 0, canvasWidth, canvasHeight);
	var pixels = id.data;
	for(var i=0; i<8; i++) {
		for(var j=0; j<8; j++) {
			var set = font[c][i] & 1 << j;
			if(set) {
				// ctx.fillRect(j*scale + x, i*scale + y, scale, scale);
				var off = ((i+y) * id.width + (j+x)) * 4;
				pixels[off] = 1;
				pixels[off + 1] = 1;
				pixels[off + 2] = 1;
				pixels[off + 3] = 255;
			}
		}
	}
	ctx.putImageData(id, 0, 0);
}

function drawChar(c, x, y) {
	_drawCharXY(c, x * charWidth, y * charHeight);
}

function putChar(ch) {
	var c = typeof(ch) === "number"? ch : ch.charCodeAt(0);
	
	if(posX == columns-1) {
		posY+=1;
		posX = 1;
	}

	if(posY == rows) {
		return;
	}
	_drawCharXY(c, posX * charWidth, posY * (charHeight + 3));
	posX++;
}

function putCharMem(ch) {
	var ch = typeof(ch) === "number"? ch : ch.charCodeAt(0);
	putChar(ch);
	mem.push(ch);
}

function tprint(str) {
	for(var i=0; i<str.length; i++) {
		putCharMem(str[i]);
	}
}

function refresh() {
	clearScreen();
	posX = 1;
	posY = 1;
	l = mem.length;
	for(var i = 0; i < l; i++) {
		putChar(mem[i]);
	}
	console.log('Refresh');
}

clearScreen();

// drawChar(1, columns-1, 0);
// for(var i=1; i<24; i++) {
// 	if(i==20) continue;
// 	drawChar(3, columns-1, i);
// }
// drawChar(4, columns-1, 20);
// drawChar(2, columns-1, 24);

// drawChar(5, 5, 5);

var text = "Hello World";

tprint(text);
// putChar(6);

setUpKey();

// drawChar(1, 8, 0);
// drawChar(1, 16, 0);
// drawChar(1, 24, 0);


// c = 0;
// var text = "****    Term 0 BASIC    ****";
// for(var i=0; i<text.length; i++) {
// 	var n = text.charCodeAt(i);
// 	drawChar(n, c * charWidth, 0);
// 	c++;
// }
// text = ">";
// c = 0;
// for(var i=0; i<text.length; i++) {
// 	var n = text.charCodeAt(i);
// 	drawChar(n, c * charWidth, 2 * charWidth);
// 	c++;
// }

// putChar('X');



// $(document).ready(function() {
// 	window.columns = 40;
// 	window.rows = 25;
// 	window.posX = 0;
// 	window.posY = 0;

// 	// (function() {
// 	// 		for(var i = 0; i < rows; i++) {
// 	// 			for(var j = 0; j < columns; j++) {
// 	// 				var element = document.createElement('div');
// 	// 				// $(element).text(" ");
// 	// 				$(element).attr('id', 's' + i + '-' + j);
// 	// 				$(element).addClass('screen-cell');
// 	// 				$('#screen').append(element);
// 	// 			}
// 	// 		}
// 	// 	})();

// 	// window.setCursor = function(x, y) {
// 	// 	$('.screen-cell').removeClass('cursor');
// 	// 	$('#s' + x + '-' + y).addClass('cursor');
// 	// }
	
// 	// setUpKey();
// 	// setCursor(posX, posY);

// 	// function setChar(char, x, y) {
// 	// 	$('#s' + x + '-' + y).text(char);
// 	// }

// 	// window.tprint = function(text) {
// 	// 	var text_len = text.length;
// 	// 	for(var i=0; i < text_len; i++) {
// 	// 		if(text[i] == '\n') {
// 	// 			posX++;
// 	// 			posY = 0;
// 	// 			continue;
// 	// 		}
// 	// 		if(posY == columns) {
// 	// 			posX++;
// 	// 			posY = 0;
// 	// 		}

// 	// 		if(posX == rows) {
// 	// 			return;
// 	// 		}

// 	// 		setChar(text[i], posX, posY);
// 	// 		posY++;
// 	// 	}
// 	// }

	

// 	// var text = "   ****     TERM 0     ****\n";
// 	// tprint(text);
// 	// tprint(">dir\n");
// 	// tprint(".\n");
// 	// tprint("..\n");
// 	// tprint("system");
// 	// setCursor(posX, posY-1);
// });