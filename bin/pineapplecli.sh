#!/bin/bash
{   #FOLD HEADER
: <<'SCRIPTINFO'

          Name: pineapplecli.sh
       Version: 0.5.5 
        Author: cvk_b
     Last Edit: Monday - January 28, 2008 2:53 AM
       Purpose: Integrated Test Environment for
                HandBrakeCLI
       LICENSE: GPL compatible Free Software; see COPYING
                at the end of this document

SCRIPTINFO
}   #FOLD HEADER_
{   #FOLD SETUP
{   #FOLD VARIABLES
# The next two lines are very important for troubleshooting
# PineAppleCLI MUST know its own directory so you may need to manually change the BASEDIR
# The jam string has been tested only on Ubuntu Dapper & OS X Darwin
BASEDIR=`dirname "$0" | sed -e 's/\/\.//g'` ; if [[ "$BASEDIR" = "." ]] ; then BASEDIR=`pwd` ; fi #BASEDIR="/Users/me/scripts/pineapple"
JAMSTRING='jam' ; SYSTEM=`uname -s` ; if [[ $SYSTEM == "Darwin" ]] ; then JAMSTRING='./jam' ; fi
COLUMNS=2
PS3=`echo -e "\n>> "`       #Select menu prompt
} #FOLD VARIABLES_
{   #FOLD FUNCTIONS
function exitwrap() {               #Preserve Exit Codes
    $1; ERR=$?
    if [ $ERR != 0 ] ; then
        echo -e "\nPineAppleCLI RESULT: FAIL"; echo -e "EXIT CODE: $ERR"; echo -n "HINT: "; echo -e "$ERRORMESSAGE"
        else echo; echo "PineAppleCLI RESULT: OK"
    fi
    ERRORMESSAGE=
}
function banner() {                 #Show an informative headline
    clear
    # echo -n \""$OPTION $OPTS"\" ; echo
    echo -e $1
}
function post() {                   #Basically, the prompt
    echo -e "$1"
    echo -n "Press <ENTER> :"; read OPTION OPTS
}
function warning() {                #Usage: warning "warning message"
    echo
    echo "***WARNING***"
    echo -e "$1"
    echo -n "Press <ENTER> to proceed or (q) to quit/return: "; read confirm
    if [ "$confirm" == "q" ]; then continue
    fi
}
function write_preset() {           #write some variables to be used upon next launch
cat << EOF > "$BASEDIR/cache/preset.1"
$NAME
$INPUTDIR
$OUTPUTDIR
$TITLEPLUS
$GUIPRESET
$AUDIO
$PICTURE
$VIDEO
$X264OPTS
$X264OPTS2
$ENCODELOGS
$INPUTBASEDIR
$CURRENTCOPY
$GUIPRESETLINENUM
EOF
}
function insertdefaults() {         #Allow insertion of defaults from case option
if [ ! -s "$BASEDIR/cache/recent.$PINEAPPLE" ]; then
echo "Inserting examples... "

cat << EOF > "$BASEDIR/cache/recent.$PINEAPPLE"
$1
$2
$3
$4
$5
EOF

fi
}
function stayclean() {              #Cache file maintenance
    cp -f "$BASEDIR/cache/recent.$PINEAPPLE" "$BASEDIR/cache/recent.$PINEAPPLE.tmp"
    grep . "$BASEDIR/cache/recent.$PINEAPPLE.tmp" | sort -u | uniq | sed '/^$/d' > "$BASEDIR/cache/recent.$PINEAPPLE"
    rm -f "$BASEDIR/cache/recent.$PINEAPPLE.tmp"
}
function read_preset_single() {     #Read a certain line of a preset
    O=$IFS IFS=$'\n'                            #$1 is the quoted cachefile name with path
    export "$3"=`sed -n "$2{p;q;}" "$1"`        #$2 is the line number requested from the preference file
    IFS=$O                                      #$3 name the variable that will be exported/read
}
function menufromfile() {           #Take a file, and make a select menu from it
O=$IFS IFS=$'\n' LINES=($(< "$BASEDIR/cache/recent.$PINEAPPLE")) IFS=$O
      select LINE in "${LINES[@]}"; do
      if [ "$LINE" ]; then
          set "$1"="$LINE"
          export "$1"                   #Export the variable for use
          export NUMCHOSEN="$REPLY"     #Needed for GUI Presets...
          break
      else
            #Delete Mechanism
            if [ \( "$REPLY" == "d" -o "$REPLY" == "D" \) ] ; then
                echo -n "Remove #: "
                DELT=; read DELT
                if [ "$DELT" -gt 0 ]; then              #make sure a number is used -TODO change to a range -le ${#LINES[@]}
                    #echo ${#LINES[@]}; read
                    sed ${DELT}d "$BASEDIR/cache/recent.$PINEAPPLE" > "$BASEDIR/cache/recent.$PINEAPPLE.tmp" 2> /dev/null #delete line
                    cp -f "$BASEDIR/cache/recent.$PINEAPPLE.tmp" "$BASEDIR/cache/recent.$PINEAPPLE"
                    stayclean
                    #eval " export $1= "
                    UNLOCK=
                fi
                break
            fi
            #Do nothing, go back
            if [ \( "$REPLY" == "k" -o "$REPLY" == "K" -o "$REPLY" == "q" \) ] ; then
                break
            fi
            #Append to cache if the menu is unlocked
            if [[ $UNLOCK -eq "1" ]]; then
                REPLY=$( echo "$REPLY" | sed -e 's/\/$//g' | awk '{gsub(/^[ \t]+|[ \t]+$/,"");print}' ) #Remove Trailing Slash, Lead & Trailing Whitespace
                export "$1"="$REPLY"
                echo "$REPLY" >> "$BASEDIR/cache/recent.$PINEAPPLE"
                
                stayclean       #debug: echo $1 is $REPLY; sleep 3
                write_preset    # Update the master preset
            fi
        break
      fi
    done
}
function read_full_preset() {       #Read a pineapplecli preset #TODO... loop it, shorten it
    touch "$BASEDIR/cache/preset.1"
    touch "$BASEDIR/cache/recent.NAME"
    touch "$BASEDIR/cache/recent.INPUTDIR"
    touch "$BASEDIR/cache/recent.TITLEPLUS"
    touch "$BASEDIR/cache/recent.GUIPRESET"
    touch "$BASEDIR/cache/recent.PICTURE"
    touch "$BASEDIR/cache/recent.AUDIO"
    touch "$BASEDIR/cache/recent.VIDEO"
    touch "$BASEDIR/cache/recent.X264OPTS"
    touch "$BASEDIR/cache/recent.X264OPTS2"
    touch "$BASEDIR/cache/recent.OUTPUTDIR"
    touch "$BASEDIR/cache/recent.ENCODELOGS"
    touch "$BASEDIR/cache/recent.CURRENTCOPY"
    touch "$BASEDIR/cache/recent.INPUTBASEDIR"
    read_preset_single "$BASEDIR/cache/preset.1" 1 "NAME"
    read_preset_single "$BASEDIR/cache/preset.1" 2 "INPUTDIR"
    read_preset_single "$BASEDIR/cache/preset.1" 3 "OUTPUTDIR"
    read_preset_single "$BASEDIR/cache/preset.1" 4 "TITLEPLUS"
    read_preset_single "$BASEDIR/cache/preset.1" 5 "GUIPRESET"
    read_preset_single "$BASEDIR/cache/preset.1" 6 "AUDIO"
    read_preset_single "$BASEDIR/cache/preset.1" 7 "PICTURE"
    read_preset_single "$BASEDIR/cache/preset.1" 8 "VIDEO"
    read_preset_single "$BASEDIR/cache/preset.1" 9 "X264OPTS"
    read_preset_single "$BASEDIR/cache/preset.1" 10 "X264OPTS2"
    read_preset_single "$BASEDIR/cache/preset.1" 11 "ENCODELOGS"
    read_preset_single "$BASEDIR/cache/preset.1" 12 "INPUTBASEDIR"
    read_preset_single "$BASEDIR/cache/preset.1" 13 "CURRENTCOPY"
    read_preset_single "$BASEDIR/cache/preset.1" 14 "GUIPRESETLINENUM"
}
function manicuretheplist() {
if [[ $SYSTEM == "Darwin" ]] ; then
cd "$BASEDIR"
ruby "${CURRENTCOPY}"/scripts/manicure.rb -p > "$BASEDIR/cache/presets.from.manicure"

cat << EOF > "$BASEDIR/cache/preset.names.tmp"
s/\:.*//g
EOF

cat << EOF > "$BASEDIR/cache/preset.strings.tmp" 
s/.*\:\ //g
EOF

sed -f "$BASEDIR/cache/preset.names.tmp" "$BASEDIR/cache/presets.from.manicure" > "$BASEDIR/cache/recent.GUIPRESET"
sed -f "$BASEDIR/cache/preset.strings.tmp" "$BASEDIR/cache/presets.from.manicure" > "$BASEDIR/cache/preset.strings.spaced"
grep . "$BASEDIR/cache/preset.strings.spaced" | uniq > "$BASEDIR/cache/preset.strings"
rm -f  "$BASEDIR/cache/preset.strings.spaced" "$BASEDIR/cache/preset.names.tmp" "$BASEDIR/cache/preset.strings.tmp" "$BASEDIR/cache/presets.from.manicure" "$BASEDIR/cache/presets"

fi
}
function forcedl() {                #A 'super clean' of libs.
    rm -rf "$CURRENTCOPY"/contrib/a52dec
    rm -rf "$CURRENTCOPY"/contrib/a52dec.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/bin
    rm -rf "$CURRENTCOPY"/contrib/config.cache
    rm -rf "$CURRENTCOPY"/contrib/faac
    rm -rf "$CURRENTCOPY"/contrib/faac.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/ffmpeg
    rm -rf "$CURRENTCOPY"/contrib/ffmpeg.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/include
    rm -rf "$CURRENTCOPY"/contrib/lame
    rm -rf "$CURRENTCOPY"/contrib/lame.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/lib
    rm -rf "$CURRENTCOPY"/contrib/libdca
    rm -rf "$CURRENTCOPY"/contrib/libdca.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/libdvdcss
    rm -rf "$CURRENTCOPY"/contrib/libdvdcss.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/libdvdread
    rm -rf "$CURRENTCOPY"/contrib/libdvdread.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/libmkv
    rm -rf "$CURRENTCOPY"/contrib/libmkv.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/libogg
    rm -rf "$CURRENTCOPY"/contrib/libogg.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/libsamplerate
    rm -rf "$CURRENTCOPY"/contrib/libsamplerate.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/libvorbis
    rm -rf "$CURRENTCOPY"/contrib/libvorbis.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/man
    rm -rf "$CURRENTCOPY"/contrib/mpeg2dec
    rm -rf "$CURRENTCOPY"/contrib/mpeg2dec.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/mpeg4ip
    rm -rf "$CURRENTCOPY"/contrib/mpeg4ip.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/share
    rm -rf "$CURRENTCOPY"/contrib/x264
    rm -rf "$CURRENTCOPY"/contrib/x264.tar.gz
    rm -rf "$CURRENTCOPY"/contrib/xvidcore
    rm -rf "$CURRENTCOPY"/contrib/xvidcore.tar.gz
    rm -rf "$CURRENTCOPY"/libhb/libhb.a
    rm -rf "$CURRENTCOPY"/libhb/libhb.dylib
    rm -rf "$CURRENTCOPY"/macosx/build
    rm -rf "$CURRENTCOPY"/HandBrake.app
    rm -rf "$CURRENTCOPY"/HandBrakeCLI
    rm -rf "$CURRENTCOPY"/config.jam
    rm -rf "$CURRENTCOPY"/contrib/DarwinContribVersion.txt
    rm -rf "$CURRENTCOPY"/contrib/*.tar.gz
}
function nukelibs() {               #Clean libs for switching between jam & make
    rm -rf "$CURRENTCOPY"/contrib/a52dec
    rm -rf "$CURRENTCOPY"/contrib/bin
    rm -rf "$CURRENTCOPY"/contrib/config.cache
    rm -rf "$CURRENTCOPY"/contrib/faac
    rm -rf "$CURRENTCOPY"/contrib/ffmpeg
    rm -rf "$CURRENTCOPY"/contrib/include
    rm -rf "$CURRENTCOPY"/contrib/lame
    rm -rf "$CURRENTCOPY"/contrib/lib
    rm -rf "$CURRENTCOPY"/contrib/libdca
    rm -rf "$CURRENTCOPY"/contrib/libdvdcss
    rm -rf "$CURRENTCOPY"/contrib/libdvdread
    rm -rf "$CURRENTCOPY"/contrib/libmkv
    rm -rf "$CURRENTCOPY"/contrib/libogg
    rm -rf "$CURRENTCOPY"/contrib/libsamplerate
    rm -rf "$CURRENTCOPY"/contrib/libvorbis
    rm -rf "$CURRENTCOPY"/contrib/man
    rm -rf "$CURRENTCOPY"/contrib/mpeg2dec
    rm -rf "$CURRENTCOPY"/contrib/mpeg4ip
    rm -rf "$CURRENTCOPY"/contrib/share
    rm -rf "$CURRENTCOPY"/contrib/x264
    rm -rf "$CURRENTCOPY"/contrib/xvidcore
    rm -rf "$CURRENTCOPY"/libhb/libhb.a
    rm -rf "$CURRENTCOPY"/libhb/libhb.dylib
    rm -rf "$CURRENTCOPY"/macosx/build
    rm -rf "$CURRENTCOPY"/HandBrake.app
    rm -rf "$CURRENTCOPY"/HandBrakeCLI
    rm -rf "$CURRENTCOPY"/config.jam
    rm -rf "$CURRENTCOPY"/contrib/DarwinContribVersion.txt
}
function mergeguiandcli() {         #Preparations for mixing gui and cli options
    GUIX264STRING=
    GUIPARAMS=
    if [[ "$GUIPRESET" != "" ]] ; then
        GUIPARAMS=`sed -n "${GUIPRESETLINENUM}{p;q;}" "$BASEDIR/cache/preset.strings" | awk -F'-x ' '{print $1;}' 2> /dev/null`
        GUIX264STRING=`sed -n "${GUIPRESETLINENUM}{p;q;}" "$BASEDIR/cache/preset.strings" | awk -F'-x ' '{print $2;}' 2> /dev/null`
    fi
#
    if   [ \( "$X264OPTS" != "" -a "$X264OPTS2" != "" \) ] ; then
        CLIX264STRING="${X264OPTS}:${X264OPTS2}"
    elif [ \( "$X264OPTS" != "" -a "$X264OPTS2" == "" \) ] ; then
        CLIX264STRING="${X264OPTS}"
    elif [ \( "$X264OPTS" == "" -a "$X264OPTS2" != "" \) ] ; then
        CLIX264STRING="${X264OPTS2}"
    else
        CLIX264STRING=
    fi
#
    if   [ \( "$GUIX264STRING" != "" -a "$CLIX264STRING" != "" \) ] ; then
        XSTRING="-x ${GUIX264STRING}:${CLIX264STRING}"
    elif [ \( "$GUIX264STRING" != "" -a "$CLIX264STRING" == "" \) ] ; then
        XSTRING="-x ${GUIX264STRING}"
    elif [ \( "$GUIX264STRING" == "" -a "$CLIX264STRING" != "" \) ] ; then
        XSTRING="-x ${CLIX264STRING}"
    else
        XSTRING=
    fi
#
}
function makeclean() {              #Force clean libs before using make
    rm -rf "$CURRENTCOPY"/HandBrake.app
    rm -rf "$CURRENTCOPY"/HandBrakeCLI
    rm -rf "$CURRENTCOPY"/config.jam
    rm -rf "$CURRENTCOPY"/contrib/DarwinContribVersion.txt
    rm -rf "$CURRENTCOPY"/contrib/include
    rm -rf "$CURRENTCOPY"/contrib/lib
    rm -rf "$CURRENTCOPY"/libhb/libhb.a
    rm -rf "$CURRENTCOPY"/macosx/build
}
function copycheck() {              #Has HB been d/l'ed the first time?
    if [ ! -d "${CURRENTCOPY}"/.svn ]; then
        banner "Downloading a new working copy..."
        svn co svn://svn.m0k.org/HandBrake/trunk/ "${CURRENTCOPY}"
    fi
}
}   #FOLD FUNCTIONS_
{   #FOLD OPENING COMMANDS
cd "${BASEDIR}"
mkdir -p "${BASEDIR}/cache"
mkdir -p "${BASEDIR}/workingcopies"
mkdir -p "${BASEDIR}/log"
read_full_preset
if [ "$CURRENTCOPY" == "" ]; then
    CURRENTCOPY="${BASEDIR}/workingcopies/hb1"
    mkdir -p "${BASEDIR}/workingcopies/hb1"
    clear
    echo "Default Working Copy Selected..."; sleep 1; #clear
    echo "Now you should use the 'update' or 'auto' command..."; sleep 3
    write_preset
fi
}   #FOLD OPENING COMMANDS_
}   #FOLD SETUP_
{   #FOLD WHILE
while [ exit != 0 ]
{   #FOLD MENU
cd "$CURRENTCOPY"
REV=`svn info "$CURRENTCOPY" | awk '/(.*)(Revision\: )(.*)/ {print $2}' 2> /dev/null`
SPACE=`df -h "${OUTPUTDIR}" | awk '{print $4}' | tail -1 2> /dev/null`
if [[ $SPACE == "" ]] ; then SPACE="?" ; fi
clear
cat <<MENU
                                                                            PineAppleCLI by cvk_b
  $CURRENTCOPY
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  BUILD              WORKING COPY          ENCODE
   (a) auto           (y) select/create     (g) start Mac GUI
   (u) svn up         (f) svn diff          (i) input search
   (j) jam            (z) nuke libs         (l) encode logs
   (m) make           (o) open dir/shell
   (v) svn log <n>    (r) c/o rev <n>
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

      Name & Ext (1): $NAME
           Input (2): $INPUTDIR
      Output Dir (3): $OUTPUTDIR $SPACE
       Titles/Ch (4): $TITLEPLUS
 Built-In Preset (5): $GUIPRESET
           Audio (6): $AUDIO
  Picture & Subs (7): $PICTURE
           Video (8): $VIDEO
     x264 Opts A (9): $X264OPTS
     x264 Opts B (0): $X264OPTS2

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  (s)can   display comma(n)d   (e)ncode   clear <num><num>                                   $REV
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MENU
}   #FOLD MENU_
do
read -p "  Make a Selection or (q)uit: " OPTION OPTS
{   #FOLD CASE
case "$OPTION" in

E|e)        # encode done here
    {
    mergeguiandcli
    clear
    [[ ! -e "${OUTPUTDIR}"/"${NAME}" ]] || warning "Overwrite?"
    clear; echo -e "\n\n"
    echo "${CURRENTCOPY}"/./HandBrakeCLI -i "${INPUTDIR}" -o "${OUTPUTDIR}"/"${NAME}" ${GUIPARAMS} ${TITLEPLUS} ${AUDIO} ${PICTURE} ${VIDEO} ${XSTRING}
    echo -e "\n"
    # some parts of the redirection ripped from palmrest
        { time {
            ((("${CURRENTCOPY}"/./HandBrakeCLI -i "${INPUTDIR}" -o "${OUTPUTDIR}"/"${NAME}" ${GUIPARAMS} ${TITLEPLUS} ${AUDIO} ${PICTURE} ${VIDEO} ${XSTRING}) 3>&1 1>&2 2>&3 | tee "${BASEDIR}"/log/"${NAME}".log) 3>&1 1>&2 2>&3)
        } } 2>&1 | tee "${BASEDIR}"/log/"${NAME}".log
    # append the command to the log file
        echo -e "\n${CURRENTCOPY}"/./HandBrakeCLI -i "${INPUTDIR}" -o "${OUTPUTDIR}"/"${NAME}" ${GUIPARAMS} ${TITLEPLUS} ${AUDIO} ${PICTURE} ${VIDEO} ${XSTRING} >> "${BASEDIR}"/log/"${NAME}".log

    echo; echo; post
    }
    ;;

N|n|D|d)    # display the command to be used
    {
    read_full_preset
    mergeguiandcli
    clear
    echo "${CURRENTCOPY}"/./HandBrakeCLI -i "${INPUTDIR}" -o "${OUTPUTDIR}"/"${NAME}" ${GUIPARAMS} ${TITLEPLUS} ${AUDIO} ${PICTURE} ${VIDEO} ${XSTRING}
    echo; echo; post
    }
    ;;

S|s)
    {
    clear
    "${CURRENTCOPY}"/./HandBrakeCLI -i "${INPUTDIR}" -t 0
    post
    }
    ;;

1)          # Name of File to be encoded
    {
    PINEAPPLE='NAME'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  Select an output filename. Use an extension. It will be used to select your video
  format if the " -f " option is not specified in the video section (num 7 on main menu).
  If the name you choose is already used, you will be prompted to overwrite.

  Current: $NAME

INFO
    insertdefaults "movie.mp4" "film.avi" "video.mkv"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

2)          # Input Directory
    {
    PINEAPPLE='INPUTDIR'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

   INPUT DIRECTORY

   Type the path to the content you are going to source (dir or file). This menu can be
   auto-populated with 'VIDEO_TS' sources by setting a base input directory (typing "i"
   on main menu).

<< $INPUTDIR

INFO
    insertdefaults "$HOME/Rips/Flick/VIDEO_TS" "/Volumes/HomeMovie/VIDEO_TS" "/mnt/dev/firewire/t1.vob"
    UNLOCK=1
    stayclean
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

3)          # Output Directory
    {
    PINEAPPLE='OUTPUTDIR'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  Type the path to an EXISTING output directory.

<< $OUTPUTDIR

INFO
    insertdefaults "$HOME/Movies" "$HOME/Desktop" "/mnt/dev/external"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    [ -d "$OUTPUTDIR" ] || ( echo "$OUTPUTDIR directory does not exist. " ; sleep 3 )
    write_preset
    }
    ;;

4)          # Titles, Chapters, Markers, Other...
    {
    PINEAPPLE='TITLEPLUS'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  TITLE, CHAPTERS, MARKERS, & MISC.,

    -t, --title <number>        Select a title to encode (0 to scan only, default: 1)
    -L, --longest               Select the longest title
    -c, --chapters <string>     Select chapters (e.g. "1-3" for chapters
                                1 to 3, or "3" for chapter 3 only,
                                default: all chapters)
    -m, --markers               Add chapter markers (mp4 output format only)
    -v, --verbose               Be verbose
    -C, --cpu                   Set CPU count (default: auto)

<< $TITLEPLUS

INFO
    insertdefaults "-L -m" "-L -v" "-t 2 -c 9-12"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

5)          # Mac GUI Presets
    {
    PINEAPPLE='GUIPRESET'
    banner "You cannot delete a mac gui preset. Press 'q' to go back."
cat <<INFO

  MAC GUI PRESETS
  PineAppleCLI options are applied AFTER gui options, therefore take priority.
  Clear a Mac GUI preset from the main menu by entering "c5" or "55".

<< $GUIPRESET

INFO
    UNLOCK=
    manicuretheplist
    menufromfile $PINEAPPLE
    GUIPRESETLINENUM=$( echo $NUMCHOSEN )
    stayclean
    write_preset
    }
    ;;

6)          # Audio Settings
    {
    PINEAPPLE='AUDIO'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  AUDIO SETTINGS

  Select audio encoder (make sure it is supported by the container/format),
  bitrate, samplerate, &  mixdown

    -E, --aencoder <string> Set audio encoder (faac/lame/vorbis/ac3, ac3
                            meaning passthrough, default: guessed)
    -B, --ab <kb/s>         Set audio bitrate (default: 128)
    -a, --audio <string>    Select audio channel(s) ("none" for no
                            audio, default: first one)
    -6, --mixdown <string>  Format for surround sound downmixing
                            (mono/stereo/dpl1/dpl2/6ch, default: dpl2)
    -R, --arate             Set audio samplerate (22.05/24/32/44.1/48 kHz)

<< $AUDIO

INFO
    insertdefaults "-B 160 -R 48 -E faac" "-B 128 -R 48 -E lame -6 stereo" "-E ac3"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

7)          # Picture Settings
    {
    PINEAPPLE='PICTURE'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  PICTURE SETTINGS

  Select aspect ratio and subtitle settings here.

    -p, --pixelratio        Store pixel aspect ratio in video stream
    -w, --width <number>    Set picture width
    -l, --height <number>   Set picture height
        --crop <T:B:L:R>    Set cropping values (default: autocrop)
    -Y, --maxHeight <#>     Set maximum height
    -X, --maxWidth <#>      Set maximum width
    -s, --subtitle <number> Select subtitle (default: none)
    -U, --subtitle-scan     Auto-Select subtitle used 10 percent of the time
                            or less. (i.e., short foreign language segments)
    -F, --subtitle-forced   Only display subtitles from the selected stream if
                            the subtitle has the forced flag set. May be used in
                            conjunction with --subtitle-scan to auto-select
                            a stream if it contains forced subtitles.
    -N, --native-language   Select subtitles with this language if it does not
          <string>          match the Audio language. Provide the language's
                            iso639-2 code (fre, eng, spa, dut, et cetera)

<< $PICTURE

INFO
    insertdefaults "-P -w 640 -s 1 -F" "-p -U -F" "-P -w 720 -s 1 -F"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

8)          # Video Settings
    {
    PINEAPPLE='VIDEO'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  $PINEAPPLE SECTION

    -e, --encoder <string>              ffmpeg,xvid,x264,x264b13,x264b30 (default: ffmpeg)
    -f, --format <string>               Container format (avi/mp4/ogm/mkv) (default: auto from ext.)
    -q, --quality <float>               Set video quality (0.0..1.0)
    -Q, --crf                           Use with -q for CRF instead of CQP (recommended)
    -S, --size <MB>                     Set target size
    -b, --vb <kb/s>                     Set video bitrate (default: 1000)
    -r, --rate                          Framerate (5/10/12/15/23.976/24/25/29.97)
    -2, --two-pass                      Use two-pass mode
    -T, --turbo                         When using 2-pass use the turbo options
    -d, --deinterlace <YM:FD:MM:QP>     yadif/mcdeint filter (default 0:-1:-1:1)
    -7, --deblock <QP:M>                pp7 filter (default 0:2)
    -8, --denoise <SL:SC:TL:TC>         hqdn3d filter (default 4:3:6:4.5)
    -9, --detelecine <L:R:T:B:SB:MP>    pullup filter (default 1:1:4:4:0:0)
    -g, --grayscale                     Grayscale encoding
    -4, --large-file                    mp4 files that can hold more than 4 GB.
                                        Note: Breaks iPod, AppleTV, & PS3 compatibility.

>> $VIDEO

INFO
    insertdefaults "-e x264 -b 2500" "-b 1000 -r 23.976" "-e x264 -b 2000 -2 -T -7 -8"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

9)          # x264 Options
    {
    PINEAPPLE='X264OPTS'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  option1=value1:option2=value2:option3=value3
  see: http://handbrake.m0k.org/trac/wiki/x264Options

<< $X264OPTS

INFO
    insertdefaults "me=umh:subq=6" "me=hex:subq=5"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

0)          # More x264 Options
    {
    PINEAPPLE='X264OPTS2'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

  option4=value4:option5=value5:option6=value6
  see: http://handbrake.m0k.org/trac/wiki/x264Options

<< $X264OPTS2

INFO
    insertdefaults "no-fast-pskip=1:trellis=2:cabac=0" "no-fast-pskip=0:trellis=1"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset
    }
    ;;

L|l|log|logs)       # Encode Logs
    {
    PINEAPPLE='ENCODELOGS'
    banner "Instructions: Select or (q)uit/return"
cat <<INFO

  View an encode log with nano...

INFO

    ENCODELOGS=
    find "$BASEDIR/log" -type f -name *.log -print >> "$BASEDIR/cache/recent.ENCODELOGS" 2> /dev/null
    stayclean
    UNLOCK=
    menufromfile $PINEAPPLE
    if [ "$ENCODELOGS" != "" ] ; then
        less -r "$ENCODELOGS"
    fi
    write_preset
    }
    ;;

12|I|i)        # Choose Base Input Directory
    {
    PINEAPPLE='INPUTBASEDIR'
    banner "Instructions: Select, type new, (k)eep, or (d)elete previous."
cat <<INFO

   INPUT BASE DIRECTORY

   Select a base input directory. It is important that you choose carefully.
   A good choice would not be too vague (i.e., " / ") or too specific (i.e.,
   " $HOME/Movies/rips/MTR/Films/Action/Movie Name/VIDEO_TS "). WHY? Because
   PineAppleCLI will search and populate your Input Dir list (num 2 on main menu)
   with 'VIDEO_TS' folders for you. A vague search would simply take a long time
   and a search too specific wouldn't show all the useful results.

   Using the above example a good choice would be: $HOME/Movies/rips/MTR

<< $INPUTBASEDIR

INFO
    insertdefaults "$HOME/Movies" "/mnt/dev/firewire/rips" "/Volumes/Hard Drive B"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    echo "Performing Search..."
    find "$INPUTBASEDIR" -name VIDEO_TS -print >> "$BASEDIR/cache/recent.INPUTDIR" 2> /dev/null; echo "done."; sleep .2
    stayclean
    write_preset
    }
    ;;

13|y|Y)     # Select/Create working copy
    {
    PINEAPPLE='CURRENTCOPY'
    banner "Instructions: Select, type new, (k)eep, or (d)elete from menu\n(PineAppleCLI will never delete a working copy from disk)."
cat <<INFO

   CURRENT WORKING COPY

   Type the path to a working copy of HandBrake or select from the menu below. HB source
   will be downloaded to this directory via (u)pdate or (a)uto from the main menu if it does
   not currently exist there.

   * Use a FULL path WITHOUT SPACES, as per HB documentation, quotes not needed
     BAD: ~/tmp/Hand Brake
     GOOD: /Users/jsmith/tmp/handbrakecopy

<< $CURRENTCOPY

INFO
    insertdefaults "$BASEDIR/workingcopies/hb1" "$BASEDIR/workingcopies/hb2" "$BASEDIR/workingcopies/hb3"
    UNLOCK=1
    menufromfile $PINEAPPLE
    UNLOCK=
    write_preset

    }
    ;;

clear|Clear)    # clear most variables
    {
    banner "Clear"
    warning "Are you sure you want to clear?"
    unset NAME
    unset INPUTDIR
    unset TITLEPLUS
    unset GUIPRESET
    unset PICTURE
    unset AUDIO
    unset VIDEO
    unset X264OPTS
    unset X264OPTS2
    }
    ;;

c1|11)          # clear
    {
    unset NAME
    write_preset
    }
    ;;

c2|22)          # clear
    {
    unset INPUTDIR
    write_preset
    }
    ;;

c3|33)          # clear
    {
    unset OUTPUTDIR
    write_preset
    }
    ;;

c4|44)          # clear
    {
    unset TITLEPLUS
    write_preset
    }
    ;;

c5|55)          # clear
    {
    unset GUIPRESET
    write_preset
    }
    ;;

c6|66)          # clear
    {
    unset AUDIO
    write_preset
    }
    ;;

c7|77)          # clear
    {
    unset PICTURE
    write_preset
    }
    ;;

c8|88)          # clear
    {
    unset VIDEO
    write_preset
    }
    ;;

c9|99)          # clear
    {
    unset X264OPTS
    write_preset
    }
    ;;

c0|00)          # clear
    {
    unset X264OPTS2
    write_preset
    }
    ;;

A|a|auto)       # Automated procedure
    {
    banner "Auto update and compile via Jam"
    copycheck
    ERRORMESSAGE="Do you have an internet connection right now?"
    banner "Updating $CURRENTCOPY \nto latest HandBrake Trunk..."
    cd "$CURRENTCOPY"
    svn update "${CURRENTCOPY}"
    ERRORMESSAGE="Working copy not configured. Try updating or reverting."
    exitwrap "./configure" && ERRORMESSAGE="Did not build. Spaces in path?" && exitwrap "$JAMSTRING"
    post "End Auto."
    }
    ;;

M|m|make)       # Compile with Make
    {

    banner "Compile HandBrake via Make"
    warning "If you are switching between 'jam' & 'make' you should go back\nand delete (z) libraries before proceeding."
    #makeclean
    ERRORMESSAGE="Working copy not configured. Try updating or reverting."
    cd "$CURRENTCOPY"
    exitwrap "./configure" && ERRORMESSAGE="Did not build. Spaces in path?" && exitwrap "make clean" && exitwrap "make"
    post "End Make."
    }
    ;;

J|j|jam)        #Compile with Jam
    {
    banner "Compile HandBrake via Jam"
    warning "If you are switching between 'jam' & 'make' you should go back\nand delete (z) libraries before proceeding."
    ERRORMESSAGE="Working copy not configured. Try updating or reverting."
    rm -rf "$CURRENTCOPY"/HandBrake.app
    rm -rf "$CURRENTCOPY"/HandBrakeCLI
    cd "$CURRENTCOPY"
    exitwrap "./configure" && ERRORMESSAGE="Did not build. Spaces in path?" && exitwrap "$JAMSTRING"
    post "End Jam."
    }
    ;;

U|u|up)            #Get the latest HB Trunk
    {
    copycheck
    cd "$CURRENTCOPY"
    ERRORMESSAGE="A network error?"
    banner "Updating $CURRENTCOPY \nto latest HandBrake Trunk..."
    exitwrap "svn update "${CURRENTCOPY}""
    REV=`svn info $CURRENT | awk '/(.*)(Revision\: )(.*)/ {print $2}'`
    ERRORMESSAGE="Could not retreive subversion log."
    exitwrap "svn log -r $REV"
    post
    }
    ;;

G|g|gui)        # Launch the Mac GUI
    {
    ERRORMESSAGE="Have you built HandBrake yet?"
    banner "Loading GUI for Mac"
#   exitwrap "$CURRENTCOPY/HandBrake.app/Contents/MacOS/./HandBrake"
    exitwrap "open "$CURRENTCOPY"/HandBrake.app"
    post
    }
    ;;

O|o|sh|shell)   # Start a sub-shell-Useful for keeping variables set
    {
    ERRORMESSAGE="Check your environment or edit this script."
    banner "Subshell..."
    exitwrap "/bin/bash --rcfile ~/.bash_profile" #You may want to change this to ~/.profile or whatever you use...
    clear
    }
    ;;

R|r|rev|revision)        # Get a specific revision for testing, if no revision number is specified, then revert to current.
    {
    cd "$CURRENTCOPY"
    banner "Checkout Revision..."
    warning "If rev number is not given, working copy will be reverted..."
    if [ "$OPTS" == "" ]; then
        OPTS=$( echo $REV )
        exitwrap "svn revert -R ."
    fi

    ERRORMESSAGE="There was problem checking out that revision."
    banner "Getting Revision $OPTS..."
    warning "Be careful with this command. It's destructive."
    exitwrap "svn update -r $OPTS"
    post
    }
    ;;

V|v)        # Usually, the devs post interesting things to read
    {
    if [ "$OPTS" == "" ]; then
        OPTS=$( echo $REV )
        #echo $OPTS; read
    fi
    ERRORMESSAGE="Could not retreive log."
    banner "Getting log for rev $OPTS..."
    exitwrap "svn log -r $OPTS"
    unset OPTS
    post
    }
    ;;

-h)             # Display the CLI help
    {
    ERRORMESSAGE="Have you build HandBrake yet?"
    banner "The command line help"
    exitwrap "$CURRENTCOPY/./HandBrakeCLI -h"
    post
    }
    ;;

F|f)
    {
    cd "$CURRENTCOPY" ; clear
    svn diff | less
#   svn diff | mate
    post
    }
    ;;

Z|z)            # Only needed if something is seriously messed up. Deletes everything except the '.svn' directory
    {
    ERRORMESSAGE="Permissions Problem?"
    banner "Force rebuild libraries. They will NOT be downloaded again.\n\nIf you DO want to re-download try 'zz' on the main menu instead of 'z'"
    warning "Last chance to change your mind..."
    nukelibs
    post "It will now take longer to build."
    }
    ;;

ZZ|zz)          # Only needed if something is seriously messed up. Deletes everything except the '.svn' directory
    {
    ERRORMESSAGE="Permissions Problem?"
    banner "Force download & rebuild libraries."
    warning "Last chance to change your mind..."
    forcedl
    post "It will now take much longer to build."
    }
    ;;

linux|presets|pre)            # faux Mac GUI Presets insertion
    {
cat << EOF > "$BASEDIR/cache/preset.strings"
 -e x264 -b 1000 -B 160 -R 48 -E faac -f mkv -m -d -p -x ref=5:mixed-refs:bframes=6:bime:weightb:b-rdo:direct=auto:b-pyramid:me=umh:subme=5:analyse=all:8x8dct:trellis=1:nr=150:no-fast-pskip:filter=2,2
 -e x264 -b 2500 -B 160 -R 48 -E faac -f mp4 -m -p -x bframes=3:ref=1:subme=5:me=umh:no-fast-pskip=1:trellis=2:cabac=0
 -e x264 -b 1800 -B 160 -R 48 -E ac3 -f mkv -m -p -x ref=16:mixed-refs:bframes=6:bime:weightb:b-rdo:direct=auto:b-pyramid:me=umh:subme=7:me-range=64:analyse=all:8x8dct:trellis=2:no-fast-pskip:no-dct-decimate:filter=-2,-1
 -b 512 -B 128 -R 48 -E faac -f mp4 -w 512 -m
 -e x264 -S 695 -B 128 -R 48 -E faac -f mp4 -w 640 -m -x ref=3:mixed-refs:bframes=6:bime:weightb:b-rdo:b-pyramid:direct=auto:me=umh:subme=6:trellis=1:analyse=all:8x8dct:no-fast-pskip
 -b 1000 -B 160 -R 48 -E faac -f mp4
 -e x264 -q 0.64709997177124023 -B 160 -R 48 -E ac3 -f mkv -m -p -x ref=3:mixed-refs:bframes=3:b-pyramid:b-rdo:bime:weightb:filter=-2,-1:subme=6:trellis=1:analyse=all:8x8dct:me=umh
 -e x264 -b 1600 -B 160 -R 48 -E ac3 -f mkv -m -p -x ref=5:mixed-refs:bframes=3:bime:weightb:b-rdo:b-pyramid:me=umh:subme=7:trellis=1:analyse=all:8x8dct:no-fast-pskip
 -e x264 -b 2000 -B 160 -R 48 -E ac3 -f mkv -m -p -x ref=3:mixed-refs:bframes=3:bime:weightb:b-rdo:direct=auto:b-pyramid:me=umh:subme=6:analyse=all:8x8dct:trellis=1:no-fast-pskip
 -e x264b30 -b 960 -B 128 -R 48 -E faac -f mp4 -w 480 -m -x cabac=0:ref=1:analyse=all:me=umh:subme=6:no-fast-pskip=1:trellis=1
 -e x264b30 -b 1500 -B 160 -R 48 -E faac -f mp4 -w 640 -m -x keyint=300:keyint-min=30:bframes=0:cabac=0:ref=1:vbv-maxrate=1500:vbv-bufsize=2000:analyse=all:me=umh:subme=6:no-fast-pskip=1
 -e x264b30 -b 700 -B 160 -R 48 -E faac -f mp4 -w 320 -m -x keyint=300:keyint-min=30:bframes=0:cabac=0:ref=1:vbv-maxrate=768:vbv-bufsize=2000:analyse=all:me=umh:subme=6:no-fast-pskip=1
 -e x264 -b 1500 -B 160 -R 48 -E faac -f mp4 -m -p -x ref=2:bframes=2:subme=5:me=umh
 -e x264 -b 2500 -B 160 -R 48 -E faac -f mp4 -m -p -x level=41:subme=5:me=umh
 -b 1024 -B 128 -R 48 -E faac -f mp4 -w 368 -l 208 -m
 -e x264 -b 2000 -B 160 -R 48 -E faac -f mp4 -m -p -x ref=3:mixed-refs:bframes=3:bime:weightb:b-rdo:direct=auto:me=umh:subme=5:analyse=all:8x8dct:trellis=1:no-fast-pskip
 -e x264 -b 1300 -B 160 -R 48 -E faac -f mkv -m -d -x ref=3:mixed-refs:bframes=6:bime:weightb:direct=auto:b-pyramid:me=umh:subme=6:analyse=all:8x8dct:trellis=1:nr=150:no-fast-pskip
EOF
cat << EOF > "$BASEDIR/cache/recent.GUIPRESET"
Animation
AppleTV
Bedlam
Blind
Broke
Classic
Constant Quality Rate
Deux Six Quatre
Film
iPhone
iPod High-Rez
iPod Low-Rez
Normal
PS3
PSP
QuickTime
Television
EOF
    }
    ;;

Q|q)            # Put all the end stuff in here
    {
    clear
    write_preset
    exit 0
    }
    ;;
esac
} #FOLD CASE_
done
}   #FOLD WHILE_
{   #FOLD COPYING
: <<'COPYING'

  pineapplecli.sh -- a bash script wrapper for HandBrakeCLI
  version 0.5.5 Monday - January 28, 2008 2:53 AM
  Copyright (c) 2007 wanderingFocus

  Modified MIT/zlib

  This script is provided 'as-is', without any express or implied
  warranty.  In no event will the author(s) be held liable for any
  damages arising from the use of this script.

  Permission is granted to anyone to use this script for any purpose,
  and to alter it and redistribute it freely, subject to the following
  restrictions:

  1. The origin of this script must not be misrepresented; you must not
     claim that you wrote the original script.
  2. Altered scripts must be plainly marked as such, and must not be
     misrepresented as being the original.
  3. This notice may not be removed or altered from any distribution.

COPYING
}   #FOLD COPYING_
