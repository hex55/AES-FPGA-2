library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AES_FROUND is
	port (
		y0, y1, y2, y3, rk0, rk1, rk2, rk3: in UNSIGNED(31 downto 0);
        x0, x1, x2, x3: out UNSIGNED(31 downto 0)
	);
end AES_FROUND;

architecture arch of AES_FROUND is

-- ROM
type ft_type is ARRAY(0 to 1023) of STD_LOGIC_VECTOR(7 downto 0);
signal ft : ft_type := (
	0 => X"A5", 1 => X"63", 2 => X"63", 3 => X"C6", 4 => X"84", 5 => X"7C", 6 => X"7C", 7 => X"F8", 8 => X"99", 9 => X"77", 10 => X"77", 11 => X"EE", 12 => X"8D", 13 => X"7B", 14 => X"7B", 15 => X"F6",
	16 => X"0D", 17 => X"F2", 18 => X"F2", 19 => X"FF", 20 => X"BD", 21 => X"6B", 22 => X"6B", 23 => X"D6", 24 => X"B1", 25 => X"6F", 26 => X"6F", 27 => X"DE", 28 => X"54", 29 => X"C5", 30 => X"C5", 31 => X"91",
	32 => X"50", 33 => X"30", 34 => X"30", 35 => X"60", 36 => X"03", 37 => X"01", 38 => X"01", 39 => X"02", 40 => X"A9", 41 => X"67", 42 => X"67", 43 => X"CE", 44 => X"7D", 45 => X"2B", 46 => X"2B", 47 => X"56",
	48 => X"19", 49 => X"FE", 50 => X"FE", 51 => X"E7", 52 => X"62", 53 => X"D7", 54 => X"D7", 55 => X"B5", 56 => X"E6", 57 => X"AB", 58 => X"AB", 59 => X"4D", 60 => X"9A", 61 => X"76", 62 => X"76", 63 => X"EC",
	64 => X"45", 65 => X"CA", 66 => X"CA", 67 => X"8F", 68 => X"9D", 69 => X"82", 70 => X"82", 71 => X"1F", 72 => X"40", 73 => X"C9", 74 => X"C9", 75 => X"89", 76 => X"87", 77 => X"7D", 78 => X"7D", 79 => X"FA",
	80 => X"15", 81 => X"FA", 82 => X"FA", 83 => X"EF", 84 => X"EB", 85 => X"59", 86 => X"59", 87 => X"B2", 88 => X"C9", 89 => X"47", 90 => X"47", 91 => X"8E", 92 => X"0B", 93 => X"F0", 94 => X"F0", 95 => X"FB",
	96 => X"EC", 97 => X"AD", 98 => X"AD", 99 => X"41", 100 => X"67", 101 => X"D4", 102 => X"D4", 103 => X"B3", 104 => X"FD", 105 => X"A2", 106 => X"A2", 107 => X"5F", 108 => X"EA", 109 => X"AF", 110 => X"AF", 111 => X"45",
	112 => X"BF", 113 => X"9C", 114 => X"9C", 115 => X"23", 116 => X"F7", 117 => X"A4", 118 => X"A4", 119 => X"53", 120 => X"96", 121 => X"72", 122 => X"72", 123 => X"E4", 124 => X"5B", 125 => X"C0", 126 => X"C0", 127 => X"9B",
	128 => X"C2", 129 => X"B7", 130 => X"B7", 131 => X"75", 132 => X"1C", 133 => X"FD", 134 => X"FD", 135 => X"E1", 136 => X"AE", 137 => X"93", 138 => X"93", 139 => X"3D", 140 => X"6A", 141 => X"26", 142 => X"26", 143 => X"4C",
	144 => X"5A", 145 => X"36", 146 => X"36", 147 => X"6C", 148 => X"41", 149 => X"3F", 150 => X"3F", 151 => X"7E", 152 => X"02", 153 => X"F7", 154 => X"F7", 155 => X"F5", 156 => X"4F", 157 => X"CC", 158 => X"CC", 159 => X"83",
	160 => X"5C", 161 => X"34", 162 => X"34", 163 => X"68", 164 => X"F4", 165 => X"A5", 166 => X"A5", 167 => X"51", 168 => X"34", 169 => X"E5", 170 => X"E5", 171 => X"D1", 172 => X"08", 173 => X"F1", 174 => X"F1", 175 => X"F9",
	176 => X"93", 177 => X"71", 178 => X"71", 179 => X"E2", 180 => X"73", 181 => X"D8", 182 => X"D8", 183 => X"AB", 184 => X"53", 185 => X"31", 186 => X"31", 187 => X"62", 188 => X"3F", 189 => X"15", 190 => X"15", 191 => X"2A",
	192 => X"0C", 193 => X"04", 194 => X"04", 195 => X"08", 196 => X"52", 197 => X"C7", 198 => X"C7", 199 => X"95", 200 => X"65", 201 => X"23", 202 => X"23", 203 => X"46", 204 => X"5E", 205 => X"C3", 206 => X"C3", 207 => X"9D",
	208 => X"28", 209 => X"18", 210 => X"18", 211 => X"30", 212 => X"A1", 213 => X"96", 214 => X"96", 215 => X"37", 216 => X"0F", 217 => X"05", 218 => X"05", 219 => X"0A", 220 => X"B5", 221 => X"9A", 222 => X"9A", 223 => X"2F",
	224 => X"09", 225 => X"07", 226 => X"07", 227 => X"0E", 228 => X"36", 229 => X"12", 230 => X"12", 231 => X"24", 232 => X"9B", 233 => X"80", 234 => X"80", 235 => X"1B", 236 => X"3D", 237 => X"E2", 238 => X"E2", 239 => X"DF",
	240 => X"26", 241 => X"EB", 242 => X"EB", 243 => X"CD", 244 => X"69", 245 => X"27", 246 => X"27", 247 => X"4E", 248 => X"CD", 249 => X"B2", 250 => X"B2", 251 => X"7F", 252 => X"9F", 253 => X"75", 254 => X"75", 255 => X"EA",
	256 => X"1B", 257 => X"09", 258 => X"09", 259 => X"12", 260 => X"9E", 261 => X"83", 262 => X"83", 263 => X"1D", 264 => X"74", 265 => X"2C", 266 => X"2C", 267 => X"58", 268 => X"2E", 269 => X"1A", 270 => X"1A", 271 => X"34",
	272 => X"2D", 273 => X"1B", 274 => X"1B", 275 => X"36", 276 => X"B2", 277 => X"6E", 278 => X"6E", 279 => X"DC", 280 => X"EE", 281 => X"5A", 282 => X"5A", 283 => X"B4", 284 => X"FB", 285 => X"A0", 286 => X"A0", 287 => X"5B",
	288 => X"F6", 289 => X"52", 290 => X"52", 291 => X"A4", 292 => X"4D", 293 => X"3B", 294 => X"3B", 295 => X"76", 296 => X"61", 297 => X"D6", 298 => X"D6", 299 => X"B7", 300 => X"CE", 301 => X"B3", 302 => X"B3", 303 => X"7D",
	304 => X"7B", 305 => X"29", 306 => X"29", 307 => X"52", 308 => X"3E", 309 => X"E3", 310 => X"E3", 311 => X"DD", 312 => X"71", 313 => X"2F", 314 => X"2F", 315 => X"5E", 316 => X"97", 317 => X"84", 318 => X"84", 319 => X"13",
	320 => X"F5", 321 => X"53", 322 => X"53", 323 => X"A6", 324 => X"68", 325 => X"D1", 326 => X"D1", 327 => X"B9", 328 => X"00", 329 => X"00", 330 => X"00", 331 => X"00", 332 => X"2C", 333 => X"ED", 334 => X"ED", 335 => X"C1",
	336 => X"60", 337 => X"20", 338 => X"20", 339 => X"40", 340 => X"1F", 341 => X"FC", 342 => X"FC", 343 => X"E3", 344 => X"C8", 345 => X"B1", 346 => X"B1", 347 => X"79", 348 => X"ED", 349 => X"5B", 350 => X"5B", 351 => X"B6",
	352 => X"BE", 353 => X"6A", 354 => X"6A", 355 => X"D4", 356 => X"46", 357 => X"CB", 358 => X"CB", 359 => X"8D", 360 => X"D9", 361 => X"BE", 362 => X"BE", 363 => X"67", 364 => X"4B", 365 => X"39", 366 => X"39", 367 => X"72",
	368 => X"DE", 369 => X"4A", 370 => X"4A", 371 => X"94", 372 => X"D4", 373 => X"4C", 374 => X"4C", 375 => X"98", 376 => X"E8", 377 => X"58", 378 => X"58", 379 => X"B0", 380 => X"4A", 381 => X"CF", 382 => X"CF", 383 => X"85",
	384 => X"6B", 385 => X"D0", 386 => X"D0", 387 => X"BB", 388 => X"2A", 389 => X"EF", 390 => X"EF", 391 => X"C5", 392 => X"E5", 393 => X"AA", 394 => X"AA", 395 => X"4F", 396 => X"16", 397 => X"FB", 398 => X"FB", 399 => X"ED",
	400 => X"C5", 401 => X"43", 402 => X"43", 403 => X"86", 404 => X"D7", 405 => X"4D", 406 => X"4D", 407 => X"9A", 408 => X"55", 409 => X"33", 410 => X"33", 411 => X"66", 412 => X"94", 413 => X"85", 414 => X"85", 415 => X"11",
	416 => X"CF", 417 => X"45", 418 => X"45", 419 => X"8A", 420 => X"10", 421 => X"F9", 422 => X"F9", 423 => X"E9", 424 => X"06", 425 => X"02", 426 => X"02", 427 => X"04", 428 => X"81", 429 => X"7F", 430 => X"7F", 431 => X"FE",
	432 => X"F0", 433 => X"50", 434 => X"50", 435 => X"A0", 436 => X"44", 437 => X"3C", 438 => X"3C", 439 => X"78", 440 => X"BA", 441 => X"9F", 442 => X"9F", 443 => X"25", 444 => X"E3", 445 => X"A8", 446 => X"A8", 447 => X"4B",
	448 => X"F3", 449 => X"51", 450 => X"51", 451 => X"A2", 452 => X"FE", 453 => X"A3", 454 => X"A3", 455 => X"5D", 456 => X"C0", 457 => X"40", 458 => X"40", 459 => X"80", 460 => X"8A", 461 => X"8F", 462 => X"8F", 463 => X"05",
	464 => X"AD", 465 => X"92", 466 => X"92", 467 => X"3F", 468 => X"BC", 469 => X"9D", 470 => X"9D", 471 => X"21", 472 => X"48", 473 => X"38", 474 => X"38", 475 => X"70", 476 => X"04", 477 => X"F5", 478 => X"F5", 479 => X"F1",
	480 => X"DF", 481 => X"BC", 482 => X"BC", 483 => X"63", 484 => X"C1", 485 => X"B6", 486 => X"B6", 487 => X"77", 488 => X"75", 489 => X"DA", 490 => X"DA", 491 => X"AF", 492 => X"63", 493 => X"21", 494 => X"21", 495 => X"42",
	496 => X"30", 497 => X"10", 498 => X"10", 499 => X"20", 500 => X"1A", 501 => X"FF", 502 => X"FF", 503 => X"E5", 504 => X"0E", 505 => X"F3", 506 => X"F3", 507 => X"FD", 508 => X"6D", 509 => X"D2", 510 => X"D2", 511 => X"BF",
	512 => X"4C", 513 => X"CD", 514 => X"CD", 515 => X"81", 516 => X"14", 517 => X"0C", 518 => X"0C", 519 => X"18", 520 => X"35", 521 => X"13", 522 => X"13", 523 => X"26", 524 => X"2F", 525 => X"EC", 526 => X"EC", 527 => X"C3",
	528 => X"E1", 529 => X"5F", 530 => X"5F", 531 => X"BE", 532 => X"A2", 533 => X"97", 534 => X"97", 535 => X"35", 536 => X"CC", 537 => X"44", 538 => X"44", 539 => X"88", 540 => X"39", 541 => X"17", 542 => X"17", 543 => X"2E",
	544 => X"57", 545 => X"C4", 546 => X"C4", 547 => X"93", 548 => X"F2", 549 => X"A7", 550 => X"A7", 551 => X"55", 552 => X"82", 553 => X"7E", 554 => X"7E", 555 => X"FC", 556 => X"47", 557 => X"3D", 558 => X"3D", 559 => X"7A",
	560 => X"AC", 561 => X"64", 562 => X"64", 563 => X"C8", 564 => X"E7", 565 => X"5D", 566 => X"5D", 567 => X"BA", 568 => X"2B", 569 => X"19", 570 => X"19", 571 => X"32", 572 => X"95", 573 => X"73", 574 => X"73", 575 => X"E6",
	576 => X"A0", 577 => X"60", 578 => X"60", 579 => X"C0", 580 => X"98", 581 => X"81", 582 => X"81", 583 => X"19", 584 => X"D1", 585 => X"4F", 586 => X"4F", 587 => X"9E", 588 => X"7F", 589 => X"DC", 590 => X"DC", 591 => X"A3",
	592 => X"66", 593 => X"22", 594 => X"22", 595 => X"44", 596 => X"7E", 597 => X"2A", 598 => X"2A", 599 => X"54", 600 => X"AB", 601 => X"90", 602 => X"90", 603 => X"3B", 604 => X"83", 605 => X"88", 606 => X"88", 607 => X"0B",
	608 => X"CA", 609 => X"46", 610 => X"46", 611 => X"8C", 612 => X"29", 613 => X"EE", 614 => X"EE", 615 => X"C7", 616 => X"D3", 617 => X"B8", 618 => X"B8", 619 => X"6B", 620 => X"3C", 621 => X"14", 622 => X"14", 623 => X"28",
	624 => X"79", 625 => X"DE", 626 => X"DE", 627 => X"A7", 628 => X"E2", 629 => X"5E", 630 => X"5E", 631 => X"BC", 632 => X"1D", 633 => X"0B", 634 => X"0B", 635 => X"16", 636 => X"76", 637 => X"DB", 638 => X"DB", 639 => X"AD",
	640 => X"3B", 641 => X"E0", 642 => X"E0", 643 => X"DB", 644 => X"56", 645 => X"32", 646 => X"32", 647 => X"64", 648 => X"4E", 649 => X"3A", 650 => X"3A", 651 => X"74", 652 => X"1E", 653 => X"0A", 654 => X"0A", 655 => X"14",
	656 => X"DB", 657 => X"49", 658 => X"49", 659 => X"92", 660 => X"0A", 661 => X"06", 662 => X"06", 663 => X"0C", 664 => X"6C", 665 => X"24", 666 => X"24", 667 => X"48", 668 => X"E4", 669 => X"5C", 670 => X"5C", 671 => X"B8",
	672 => X"5D", 673 => X"C2", 674 => X"C2", 675 => X"9F", 676 => X"6E", 677 => X"D3", 678 => X"D3", 679 => X"BD", 680 => X"EF", 681 => X"AC", 682 => X"AC", 683 => X"43", 684 => X"A6", 685 => X"62", 686 => X"62", 687 => X"C4",
	688 => X"A8", 689 => X"91", 690 => X"91", 691 => X"39", 692 => X"A4", 693 => X"95", 694 => X"95", 695 => X"31", 696 => X"37", 697 => X"E4", 698 => X"E4", 699 => X"D3", 700 => X"8B", 701 => X"79", 702 => X"79", 703 => X"F2",
	704 => X"32", 705 => X"E7", 706 => X"E7", 707 => X"D5", 708 => X"43", 709 => X"C8", 710 => X"C8", 711 => X"8B", 712 => X"59", 713 => X"37", 714 => X"37", 715 => X"6E", 716 => X"B7", 717 => X"6D", 718 => X"6D", 719 => X"DA",
	720 => X"8C", 721 => X"8D", 722 => X"8D", 723 => X"01", 724 => X"64", 725 => X"D5", 726 => X"D5", 727 => X"B1", 728 => X"D2", 729 => X"4E", 730 => X"4E", 731 => X"9C", 732 => X"E0", 733 => X"A9", 734 => X"A9", 735 => X"49",
	736 => X"B4", 737 => X"6C", 738 => X"6C", 739 => X"D8", 740 => X"FA", 741 => X"56", 742 => X"56", 743 => X"AC", 744 => X"07", 745 => X"F4", 746 => X"F4", 747 => X"F3", 748 => X"25", 749 => X"EA", 750 => X"EA", 751 => X"CF",
	752 => X"AF", 753 => X"65", 754 => X"65", 755 => X"CA", 756 => X"8E", 757 => X"7A", 758 => X"7A", 759 => X"F4", 760 => X"E9", 761 => X"AE", 762 => X"AE", 763 => X"47", 764 => X"18", 765 => X"08", 766 => X"08", 767 => X"10",
	768 => X"D5", 769 => X"BA", 770 => X"BA", 771 => X"6F", 772 => X"88", 773 => X"78", 774 => X"78", 775 => X"F0", 776 => X"6F", 777 => X"25", 778 => X"25", 779 => X"4A", 780 => X"72", 781 => X"2E", 782 => X"2E", 783 => X"5C",
	784 => X"24", 785 => X"1C", 786 => X"1C", 787 => X"38", 788 => X"F1", 789 => X"A6", 790 => X"A6", 791 => X"57", 792 => X"C7", 793 => X"B4", 794 => X"B4", 795 => X"73", 796 => X"51", 797 => X"C6", 798 => X"C6", 799 => X"97",
	800 => X"23", 801 => X"E8", 802 => X"E8", 803 => X"CB", 804 => X"7C", 805 => X"DD", 806 => X"DD", 807 => X"A1", 808 => X"9C", 809 => X"74", 810 => X"74", 811 => X"E8", 812 => X"21", 813 => X"1F", 814 => X"1F", 815 => X"3E",
	816 => X"DD", 817 => X"4B", 818 => X"4B", 819 => X"96", 820 => X"DC", 821 => X"BD", 822 => X"BD", 823 => X"61", 824 => X"86", 825 => X"8B", 826 => X"8B", 827 => X"0D", 828 => X"85", 829 => X"8A", 830 => X"8A", 831 => X"0F",
	832 => X"90", 833 => X"70", 834 => X"70", 835 => X"E0", 836 => X"42", 837 => X"3E", 838 => X"3E", 839 => X"7C", 840 => X"C4", 841 => X"B5", 842 => X"B5", 843 => X"71", 844 => X"AA", 845 => X"66", 846 => X"66", 847 => X"CC",
	848 => X"D8", 849 => X"48", 850 => X"48", 851 => X"90", 852 => X"05", 853 => X"03", 854 => X"03", 855 => X"06", 856 => X"01", 857 => X"F6", 858 => X"F6", 859 => X"F7", 860 => X"12", 861 => X"0E", 862 => X"0E", 863 => X"1C",
	864 => X"A3", 865 => X"61", 866 => X"61", 867 => X"C2", 868 => X"5F", 869 => X"35", 870 => X"35", 871 => X"6A", 872 => X"F9", 873 => X"57", 874 => X"57", 875 => X"AE", 876 => X"D0", 877 => X"B9", 878 => X"B9", 879 => X"69",
	880 => X"91", 881 => X"86", 882 => X"86", 883 => X"17", 884 => X"58", 885 => X"C1", 886 => X"C1", 887 => X"99", 888 => X"27", 889 => X"1D", 890 => X"1D", 891 => X"3A", 892 => X"B9", 893 => X"9E", 894 => X"9E", 895 => X"27",
	896 => X"38", 897 => X"E1", 898 => X"E1", 899 => X"D9", 900 => X"13", 901 => X"F8", 902 => X"F8", 903 => X"EB", 904 => X"B3", 905 => X"98", 906 => X"98", 907 => X"2B", 908 => X"33", 909 => X"11", 910 => X"11", 911 => X"22",
	912 => X"BB", 913 => X"69", 914 => X"69", 915 => X"D2", 916 => X"70", 917 => X"D9", 918 => X"D9", 919 => X"A9", 920 => X"89", 921 => X"8E", 922 => X"8E", 923 => X"07", 924 => X"A7", 925 => X"94", 926 => X"94", 927 => X"33",
	928 => X"B6", 929 => X"9B", 930 => X"9B", 931 => X"2D", 932 => X"22", 933 => X"1E", 934 => X"1E", 935 => X"3C", 936 => X"92", 937 => X"87", 938 => X"87", 939 => X"15", 940 => X"20", 941 => X"E9", 942 => X"E9", 943 => X"C9",
	944 => X"49", 945 => X"CE", 946 => X"CE", 947 => X"87", 948 => X"FF", 949 => X"55", 950 => X"55", 951 => X"AA", 952 => X"78", 953 => X"28", 954 => X"28", 955 => X"50", 956 => X"7A", 957 => X"DF", 958 => X"DF", 959 => X"A5",
	960 => X"8F", 961 => X"8C", 962 => X"8C", 963 => X"03", 964 => X"F8", 965 => X"A1", 966 => X"A1", 967 => X"59", 968 => X"80", 969 => X"89", 970 => X"89", 971 => X"09", 972 => X"17", 973 => X"0D", 974 => X"0D", 975 => X"1A",
	976 => X"DA", 977 => X"BF", 978 => X"BF", 979 => X"65", 980 => X"31", 981 => X"E6", 982 => X"E6", 983 => X"D7", 984 => X"C6", 985 => X"42", 986 => X"42", 987 => X"84", 988 => X"B8", 989 => X"68", 990 => X"68", 991 => X"D0",
	992 => X"C3", 993 => X"41", 994 => X"41", 995 => X"82", 996 => X"B0", 997 => X"99", 998 => X"99", 999 => X"29", 1000 => X"77", 1001 => X"2D", 1002 => X"2D", 1003 => X"5A", 1004 => X"11", 1005 => X"0F", 1006 => X"0F", 1007 => X"1E",
	1008 => X"CB", 1009 => X"B0", 1010 => X"B0", 1011 => X"7B", 1012 => X"FC", 1013 => X"54", 1014 => X"54", 1015 => X"A8", 1016 => X"D6", 1017 => X"BB", 1018 => X"BB", 1019 => X"6D", 1020 => X"3A", 1021 => X"16", 1022 => X"16", 1023 => X"2C"
);

begin

process (ft, y0, y1, y2, y3, rk0, rk1, rk2, rk3)
begin

	x0 <= unsigned(std_logic_vector(rk0) xor ((ft(to_integer(y0( 7 downto  0) & "00")    ) & ft(to_integer(y0( 7 downto  0) & "00") + 1) & ft(to_integer(y0( 7 downto  0) & "00") + 2) & ft(to_integer(y0( 7 downto  0) & "00") + 3))) xor
	                                         ((ft(to_integer(y1(15 downto  8) & "00") + 1) & ft(to_integer(y1(15 downto  8) & "00") + 2) & ft(to_integer(y1(15 downto  8) & "00") + 3) & ft(to_integer(y1(15 downto  8) & "00")    ))) xor
	                                         ((ft(to_integer(y2(23 downto 16) & "00") + 2) & ft(to_integer(y2(23 downto 16) & "00") + 3) & ft(to_integer(y2(23 downto 16) & "00")    ) & ft(to_integer(y2(23 downto 16) & "00") + 1))) xor
	                                         ((ft(to_integer(y3(31 downto 24) & "00") + 3) & ft(to_integer(y3(31 downto 24) & "00")    ) & ft(to_integer(y3(31 downto 24) & "00") + 1) & ft(to_integer(y3(31 downto 24) & "00") + 2))));

	x1 <= unsigned(std_logic_vector(rk1) xor ((ft(to_integer(y1( 7 downto  0) & "00")    ) & ft(to_integer(y1( 7 downto  0) & "00") + 1) & ft(to_integer(y1( 7 downto  0) & "00") + 2) & ft(to_integer(y1( 7 downto  0) & "00") + 3))) xor
	                                         ((ft(to_integer(y2(15 downto  8) & "00") + 1) & ft(to_integer(y2(15 downto  8) & "00") + 2) & ft(to_integer(y2(15 downto  8) & "00") + 3) & ft(to_integer(y2(15 downto  8) & "00")    ))) xor
	                                         ((ft(to_integer(y3(23 downto 16) & "00") + 2) & ft(to_integer(y3(23 downto 16) & "00") + 3) & ft(to_integer(y3(23 downto 16) & "00")    ) & ft(to_integer(y3(23 downto 16) & "00") + 1))) xor
	                                         ((ft(to_integer(y0(31 downto 24) & "00") + 3) & ft(to_integer(y0(31 downto 24) & "00")    ) & ft(to_integer(y0(31 downto 24) & "00") + 1) & ft(to_integer(y0(31 downto 24) & "00") + 2))));

	x2 <= unsigned(std_logic_vector(rk2) xor ((ft(to_integer(y2( 7 downto  0) & "00")    ) & ft(to_integer(y2( 7 downto  0) & "00") + 1) & ft(to_integer(y2( 7 downto  0) & "00") + 2) & ft(to_integer(y2( 7 downto  0) & "00") + 3))) xor
	                                         ((ft(to_integer(y3(15 downto  8) & "00") + 1) & ft(to_integer(y3(15 downto  8) & "00") + 2) & ft(to_integer(y3(15 downto  8) & "00") + 3) & ft(to_integer(y3(15 downto  8) & "00")    ))) xor
	                                         ((ft(to_integer(y0(23 downto 16) & "00") + 2) & ft(to_integer(y0(23 downto 16) & "00") + 3) & ft(to_integer(y0(23 downto 16) & "00")    ) & ft(to_integer(y0(23 downto 16) & "00") + 1))) xor
	                                         ((ft(to_integer(y1(31 downto 24) & "00") + 3) & ft(to_integer(y1(31 downto 24) & "00")    ) & ft(to_integer(y1(31 downto 24) & "00") + 1) & ft(to_integer(y1(31 downto 24) & "00") + 2))));

	x3 <= unsigned(std_logic_vector(rk3) xor ((ft(to_integer(y3( 7 downto  0) & "00")    ) & ft(to_integer(y3( 7 downto  0) & "00") + 1) & ft(to_integer(y3( 7 downto  0) & "00") + 2) & ft(to_integer(y3( 7 downto  0) & "00") + 3))) xor
	                                         ((ft(to_integer(y0(15 downto  8) & "00") + 1) & ft(to_integer(y0(15 downto  8) & "00") + 2) & ft(to_integer(y0(15 downto  8) & "00") + 3) & ft(to_integer(y0(15 downto  8) & "00")    ))) xor
	                                         ((ft(to_integer(y1(23 downto 16) & "00") + 2) & ft(to_integer(y1(23 downto 16) & "00") + 3) & ft(to_integer(y1(23 downto 16) & "00")    ) & ft(to_integer(y1(23 downto 16) & "00") + 1))) xor
	                                         ((ft(to_integer(y2(31 downto 24) & "00") + 3) & ft(to_integer(y2(31 downto 24) & "00")    ) & ft(to_integer(y2(31 downto 24) & "00") + 1) & ft(to_integer(y2(31 downto 24) & "00") + 2))));

end process;

end arch;
