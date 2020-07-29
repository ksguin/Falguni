# [Ubuntu](https://ubuntu.com/) ([GNOME](https://www.gnome.org/gnome-3/)) All-in-One Debloat + Set-Up
A must-have GUI-based shell-script for a clean, hassle-free setup for [Ubuntu](https://ubuntu.com/) and Ubuntu-based distros, especially handy if you're new to Linux.

***Disclaimer:** Tested on [Zorin OS 15.2](https://zorinos.com/) (based on Ubuntu 18.04.2 LTS)*

# Installation
No need to install! Download the zip, extract, and you're good to go!

- Download [Ubuntu-AIO_Debloat-SetUp](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/archive/master.zip) in your desired location.
- Extract the Downloaded Zip file & Navigate to the extracted directory.
- Open [Ubuntu-AIO_Debloat-SetUp](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/archive/master.zip) folder, then *Right-click* in an empty space > *'Open in Terminal'*
    > Don't worry, you don't need to face Terminal apart from this command! ^_^
- Run the following command -

  `sudo bash run.sh`
  
  ***Note:** You can run individual scripts too from [Scripts](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/tree/master/Scripts) folder, however [run.sh](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/blob/master/run.sh) provides you the same choices, so it is recommended to proceed as mentioned above!*
  
# Features
- ## Font List ([delete_font.sh](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/blob/master/Scripts/delete_font.sh))
  The following fonts will be available in options in _checklist_ to be _removed_.  
  I have pre-ticked most of them to remove _(you may change it for sure)_, mind you, the necessary system fonts for various languages are untouched for stability!
  
    | Status			| Font	 		| Description 				 	|
    | :---: 			| :------		| -------------------------------------- 	|
    | <ul><li> [x] </li></ul>	| fonts-arabeyes 	| A set of TrueType Arabic fonts	 	|
    | <ul><li> [x] </li></ul>	| fonts-arphic-* 	| Sets of Chinese Unicode/TrueType font	 	|
    | <ul><li> [x] </li></ul>	| fonts-beng* 		| Metapackage of Bengali and Assamese fonts 	|
    | <ul><li> [x] </li></ul>	| fonts-droid-fallback 	| Handheld device font with extensive support (fallback) |
    | <ul><li> [x] </li></ul>	| fonts-gargi 		| OpenType Devanagari font		 	|
    | <ul><li> [x] </li></ul>	| fonts-gubbi 		| Gubbi free font for Kannada script	 	|
    | <ul><li> [x] </li></ul>	| fonts-gujr* 		| Metapackage of all Gujarati fonts	 	|
    | <ul><li> [x] </li></ul>	| fonts-guru* 		| Metapackage of all Punjabi fonts	 	|
    | <ul><li> [x] </li></ul>	| fonts-kacst* 		| KACST free TrueType Arabic fonts	 	|
    | <ul><li> [x] </li></ul>	| fonts-kalapi 		| Kalapi Gujarati Unicode font		 	|
    | <ul><li> [x] </li></ul>	| fonts-khmeros-core 	| Unicode fonts for the Khmer language of Cambodia |
    | <ul><li> [x] </li></ul>	| fonts-lao 		| TrueType font for Lao language	 	|
    | <ul><li> [x] </li></ul>	| fonts-lklug-sinhala 	| Unicode Sinhala font by LKLUG		 	|
    | <ul><li> [x] </li></ul>	| fonts-lohit-* 	| Sets of Lohit TrueType Indic fonts	 	|
    | <ul><li> [x] </li></ul>	| fonts-nakula 		| Free Unicode compliant Devanagari font 	|
    | <ul><li> [x] </li></ul>	| fonts-nanum 		| Nanum Korean fonts			 	|
    | <ul><li> [x] </li></ul>	| fonts-navilu 		| Handwriting font for Kannada		 	|
    | <ul><li> [x] </li></ul>	| fonts-noto-cjk 	| No Tofu font families with large Unicode coverage |
    | <ul><li> [x] </li></ul>	| fonts-orya-extra 	| Free fonts for Odia script		 	|
    | <ul><li> [x] </li></ul>	| fonts-pagul 		| Free TrueType font for the Sourashtra language |
    | <ul><li> [x] </li></ul>	| fonts-sahadeva 	| Free Unicode compliant Devanagari font 	|
    | <ul><li> [x] </li></ul>	| fonts-samyak-* 	| Metapackage of all Samyak TrueType fonts 	|
    | <ul><li> [x] </li></ul>	| fonts-sarai 		| TrueType font for Devanagari script	 	|
    | <ul><li> [x] </li></ul>	| fonts-sil-abyssinica 	| Unicode font for Ethiopic script	 	|
    | <ul><li> [x] </li></ul>	| fonts-sil-padauk 	| Burmese Unicode TrueType font		 	|
    | <ul><li> [x] </li></ul>	| fonts-smc 		| Metapackage of TrueType fonts for Malayalam Language |
    | <ul><li> [x] </li></ul>	| fonts-takao-pgothic 	| Japanese gothic and mincho scalable fonts 	|
    | <ul><li> [x] </li></ul>	| fonts-telu-extra 	| Free fonts for Telugu script		 	|
    | <ul><li> [x] </li></ul>	| fonts-tibetan-machine | Font for Tibetan, Dzongkha and Ladakhi 	|
    | <ul><li> [x] </li></ul>	| fonts-tlwg-* 		| Set of all Thai fonts for LaTeX from TLWG	|
    | <ul><li> [x] </li></ul>	| fonts-wqy-microhei 	| Sans-serif style CJK font derived from Droid 	|
    
- ## Debloat List ([delete_bloat.sh](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/blob/master/Scripts/delete_bloat.sh))
  The following apps will be available in options in _checklist_ to be _removed_, along with its configuration files & dependencies.  
  I have pre-ticked most of them to remove _(you may change it for sure)_, leaving a bare minimum apps required for viewing photos/utility.

  * ### Audio

    | Status			| Software 		| Description 				 |
    | :---: 			| :------		| -------------------------------------- |
    | <ul><li> [x] </li></ul>	| rhythmbox 		| Default Music Player for GNOME	 |
    
  * ### Email Client
  
    | Status			| Software 		| Description 						 |
    | :---: 			| :------		| ------------------------------------------------------ |
    | <ul><li> [x] </li></ul>	| evolution 		| Default GNOME Email & Personal Information Manager	 |
    
  * ### Games
    
    | Status			| Software 		| Description 						 |
    | :---: 			| :------		| ------------------------------------------------------ |
    | <ul><li> [x] </li></ul>	| aisleriot 		| Collection of Card Games	 			 |
    | <ul><li> [x] </li></ul>	| gnome-mahjongg	| Solitare version of Eastern tile game, Mahjongg 	 |
    | <ul><li> [x] </li></ul>	| gnome-mines	 	| A Puzzle Game where you locate Mines	 		 |
    | <ul><li> [x] </li></ul>	| gnome-sudoku	 	| The Japanese logic Game, Sudoku			 |
    | <ul><li> [x] </li></ul>	| quadrapassel	 	| The classic falling-block Game, Tetris		 |

  * ### Photo
    
    | Status			| Software 	| Description 						 |
    | :---: 			| :------	| ------------------------------------------------------ |
    | <ul><li> [x] </li></ul>	| cheese 	| Webcam application for GNOME Desktop 			 |
    | <ul><li> [ ] </li></ul>	| eog 		| Eye of GNOME is the Default Image Viewer		 |
    | <ul><li> [x] </li></ul>	| gimp 		| A versatile Image & Graphics Manipulation Software 	 |
    | <ul><li> [x] </li></ul>	| shotwell 	| An Image Organizer & simple Image Editor for GNOME	 |
    
  * ### Utility
  
    | Status			| Software 		| Description 						 |
    | :---: 			| :------		| ------------------------------------------------------ |
    | <ul><li> [x] </li></ul>	| brasero 		| GNOME application to burn CD/DVD 			 |
    | <ul><li> [x] </li></ul>	| deja-dup 		| Simple backup tool for GNOME 				 |
    | <ul><li> [ ] </li></ul>	| gnome-font-viewer 	| Shows overview of Installed Fonts in GNOME 		 |
    | <ul><li> [x] </li></ul>	| gnome-calendar 	| Simple & Beautiful Calendar application for GNOME	 |
    | <ul><li> [x] </li></ul>	| gnome-characters 	| Utility to find & insert unusual characters in GNOME	 |
    | <ul><li> [x] </li></ul>	| gnome-clocks	 	| Stopwatch, timer & world clock in GNOME		 |
    | <ul><li> [x] </li></ul>	| gnome-contacts 	| Integrated contact address book for GNOME		 |
    | <ul><li> [x] </li></ul>	| gnome-maps	 	| A simple map client for GNOME 			 |
    | <ul><li> [x] </li></ul>	| remmina	 	| Default remote desktop client for Linux		 |
    | <ul><li> [x] </li></ul>	| yelp		 	| Default help viewer in GNOME				 |
    
  * ### Video
  
    | Status			| Software 	| Description 						 |
    | :---: 			| :------	| ------------------------------------------------------ |
    | <ul><li> [x] </li></ul>	| pitivi 	| An open-source, free non-linear video editor for GNOME |
    | <ul><li> [x] </li></ul>	| totem 	| A movie player for GNOME desktop 			 |
    
- ## Install List ([install_software.sh](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/blob/master/Scripts/install_software.sh))
  The following apps will be available in options in _checklist_ to be _installed_, based on its Category.
  I have pre-ticked some of the essential/mostly used Software(s), you surely have the full control though!
  
  * ### Audio & Video
        
    | Status			| Software 	| Description 		|
    | :---: 			| :------	| --------------------- |
    | <ul><li> [ ] </li></ul>	| Spotify 	| Spotify Music Player  |
    | <ul><li> [x] </li></ul>	| VLC 		| VLC Media Player 	|
    
  * ### Communication & Browsers
        
    | Status			| Software 	| Description 				     |
    | :---: 			| :------ 	| ------------------------------------------ |
    | <ul><li> [ ] </li></ul>	| Discord 	| All-in-one voice and text chat for Gamers  |
    | <ul><li> [x] </li></ul>	| Google Chrome	| A cross-platform web browser by Google     |
    
  * ### Utilities
    
    | Status			| Software 	 | Description 				      |
    | :---: 			| :------ 	 | ------------------------------------------ |
    | <ul><li> [ ] </li></ul>	| Android Studio | Android Studio IDE for Android	      |
    | <ul><li> [x] </li></ul>	| Stacer	 | Linux System Optimizer & Monitoring	      |

## Contributing
Thanks for your interest in contributing! There are many ways to contribute to this project. Get started [here](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/blob/master/Documentation/CONTRIBUTING.md).

## Code of Conduct
Contributor Covenant [Code of Conduct](https://github.com/ksguin/Ubuntu-AIO_Debloat-SetUp/blob/master/Documentation/CODE_OF_CONDUCT.md).

## License
[MIT](https://choosealicense.com/licenses/mit/)



