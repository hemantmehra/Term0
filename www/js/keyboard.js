function setUpKey() {
	$(document).on('keydown', function(e) {
		$('#key-info').text(e.code);
		if(e.code.includes("Key")) {
			var ch = e.code.replace('Key', '');
			putChar(ch);
		}
		if(e.code == 'Space') {
			putChar(' ');
		}
		// if(e.code == 'ArrowRight') {
		// 	posY = posY == (columns - 1) ? posY: posY + 1;
		// }
		// if(e.code == 'ArrowLeft') {
		// 	posY = posY == 0 ? posY: posY - 1;
		// }
		// if(e.code == 'ArrowUp') {
		// 	posX = posX == 0 ? posX: posX - 1;
		// }
		// if(e.code == 'ArrowDown') {
		// 	posX = posX == (rows - 1) ? posX: posX + 1;
		// }
		// // if(e.code == 'Enter') {
		// // 	posX++;
		// // 	posY = 0;
		// // }
		// setCursor(posX, posY);
		e.preventDefault();
	});
}
