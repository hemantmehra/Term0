;;; File Table entry size = 16 bytes
;;; Byte 	Purpose
;;; ------------------
;;; 0-9		File name
;;; 10-12	Extension
;;; 13		Directory Entry - 0h based # of file table entries
;;; 14		Starting sector i.e. 6h would be start in sector 6.
;;; 15		File Size (# of sectors) 0-255 sectors.
;;;			Max size of 1 file entry = 127.5 KB
;;;			Max size overall 255 * 512 * 255 = 32 MB 

;;  0-9		     10-12  13   14   15

db 'bootsec   ', 'bin', 0h, 1h, 1h, \
   'kernel    ', 'bin', 0h, 2h, 3h, \
   'fileTable ', 'txt', 0h, 5h, 1h, \
   'calculator', 'bin', 0h, 6h, 1h

times 512-($-$$) db 0
