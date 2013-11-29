#!/bin/sh
###############################################################################
#                                                                             #
# create geocaching files for navigation devices                              #
#                                                                             #
# @version: 1.0.0                                                             #
# @author: Steiner Patrick <patrick@helmsdeep.at>                             #
# @date: 29.11.2013 22:31                                                     #
# License: GPL                                                                #
# http://www.fsf.org/licenses/gpl.htmlfree for all                            #
#                                                                             #
###############################################################################

#usage example:  convert2navi.sh -c 1234567 -t navigon

#navigon settings
NAVIGONSTYLE="navigon.style"

#aj-gps files
AJZIP=at_gc.zip

AJCITO=at_gc_cito
AJEARTH=at_gc_earthcache
AJEVENT=at_gc_event
AJLETTER=at_gc_event
AJMULTI=at_gc_multi
AJTRADI=at_gc_tradi
AJUNKNOWN=at_gc_unknown
AJVIRTUAL=at_gc_virtual
AJWEBCAM=at_gc_webcam
AJWHERIGO=at_gc_wherigo

# check for core applications
function check_apps()
{
	# unzip
	if [ ! -x /usr/bin/unzip ]; then
		echo "ERROR: unzip not found"
		exit -1
	fi
  
	# gpsbabel
	if [ ! -x /usr/local/bin/gpsbabel ]; then
		echo "ERROR: gpsbabel not found"
		exit -1
	fi
}

# cleans up the current directory
function clean_directory()
{
  echo "Cleaning up current directory..."
  rm -rf *.gpx
  rm -rf *.ov2
  rm -rf *.bmp
  rm -rf *.csv
  rm -f README.txt
}

function usage()
{
	cat << EOF
usage: $0 options

OPTIONS:
  -q <pqnumber> The pocket query number
  -t <type>     Type: tomtom or navigon
  -c            Cleanup current directory
  -h            Show this message

EOF
}

function unzip_files()
{
	if [ ! -f $PQNUMBER.zip ]; then
		echo "ERROR: Pocket query file (${PQNUMBER}.zip) not found"
		exit -1
	fi
  
	if [ ! -f $AJZIP ]; then
		echo "ERROR: Caches file ($AJZIP) not found"
		exit -1
	fi
  
  unzip $PQNUMBER.zip
  unzip $AJZIP
}

function convert_tomtom2gpx()
{
  echo "Converting TomTom (.ov2) files to gpx..."
  
  gpsbabel -i tomtom -f $AJCITO.ov2 -o gpx -F $AJCITO.gpx
  gpsbabel -i tomtom -f $AJEARTH.ov2 -o gpx -F $AJEARTH.gpx
  gpsbabel -i tomtom -f $AJEVENT.ov2 -o gpx -F $AJEVENT.gpx
  gpsbabel -i tomtom -f $AJLETTER.ov2 -o gpx -F $AJLETTER.gpx
  gpsbabel -i tomtom -f $AJMULTI.ov2 -o gpx -F $AJMULTI.gpx
  gpsbabel -i tomtom -f $AJTRADI.ov2 -o gpx -F $AJTRADI.gpx
  gpsbabel -i tomtom -f $AJUNKNOWN.ov2 -o gpx -F $AJUNKNOWN.gpx
  gpsbabel -i tomtom -f $AJVIRTUAL.ov2 -o gpx -F $AJVIRTUAL.gpx
  gpsbabel -i tomtom -f $AJWEBCAM.ov2 -o gpx -F $AJWEBCAM.gpx
  gpsbabel -i tomtom -f $AJWHERIGO.ov2 -o gpx -F $AJWHERIGO.gpx
}

function remove_myfinds()
{
  echo "Removing my finds..."
  
  gpsbabel -i gpx -f $AJCITO.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJCITO}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJEARTH.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJEARTH}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJEVENT.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJEVENT}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJLETTER.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJLETTER}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJMULTI.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJMULTI}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJTRADI.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJTRADI}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJUNKNOWN.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJUNKNOWN}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJVIRTUAL.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJVIRTUAL}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJWEBCAM.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJWEBCAM}_${PQNUMBER}.gpx
  gpsbabel -i gpx -f $AJWHERIGO.gpx -f $PQNUMBER.gpx -x duplicate,location,shortname -o gpx -F ${AJWHERIGO}_${PQNUMBER}.gpx
}

function create_navigonfile()
{
  echo "Creating Navigon files..."
  
  gpsbabel -i gpx -f ${AJCITO}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJCITO.csv
  gpsbabel -i gpx -f ${AJEARTH}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJEARTH.csv
  gpsbabel -i gpx -f ${AJEVENT}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJEVENT.csv
  gpsbabel -i gpx -f ${AJLETTER}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJLETTER.csv
  gpsbabel -i gpx -f ${AJMULTI}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJMULTI.csv
  gpsbabel -i gpx -f ${AJTRADI}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJTRADI.csv
  gpsbabel -i gpx -f ${AJUNKNOWN}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJUNKNOWN.csv
  gpsbabel -i gpx -f ${AJVIRTUAL}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJVIRTUAL.csv
  gpsbabel -i gpx -f ${AJWEBCAM}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJWEBCAM.csv
  gpsbabel -i gpx -f ${AJWHERIGO}_${PQNUMBER}.gpx -o csv,style=navigon.style -F $AJWHERIGO.csv
  
  echo "Done. Now copy the .cvs files and the bmp files to the Navigon device"
}

function create_tomtomfile()
{
  echo "Creating TomTom files..."
  
  gpsbabel -i gpx -f ${AJCITO}_${PQNUMBER}.gpx -o tomtom -F $AJCITO.ov2
  gpsbabel -i gpx -f ${AJEARTH}_${PQNUMBER}.gpx -o tomtom -F $AJEARTH.ov2
  gpsbabel -i gpx -f ${AJEVENT}_${PQNUMBER}.gpx -o tomtom -F $AJEVENT.ov2
  gpsbabel -i gpx -f ${AJLETTER}_${PQNUMBER}.gpx -o tomtom -F $AJLETTER.ov2
  gpsbabel -i gpx -f ${AJMULTI}_${PQNUMBER}.gpx -o tomtom -F $AJMULTI.ov2
  gpsbabel -i gpx -f ${AJTRADI}_${PQNUMBER}.gpx -o tomtom -F $AJTRADI.ov2
  gpsbabel -i gpx -f ${AJUNKNOWN}_${PQNUMBER}.gpx -o tomtom -F $AJUNKNOWN.ov2
  gpsbabel -i gpx -f ${AJVIRTUAL}_${PQNUMBER}.gpx -o tomtom -F $AJVIRTUAL.ov2
  gpsbabel -i gpx -f ${AJWEBCAM}_${PQNUMBER}.gpx -o tomtom -F $AJWEBCAM.ov2
  gpsbabel -i gpx -f ${AJWHERIGO}_${PQNUMBER}.gpx -o tomtom -F $AJWHERIGO.ov2
  
  echo "Done. Now copy the .ov2 files and the bmp files to the TomTom device"
}

###############################################################################
# MAIN                                                                        #
###############################################################################

check_apps

while getopts chq:t: OPTION
do
  case $OPTION in
    c)
      clean_directory
      exit 0
    	;;
    h)
      usage
      exit 0
      ;;
    q)
      PQNUMBER=$OPTARG
      ;;
    t)
      TYP=$OPTARG
      ;;
    \?)
    	usage >&2
    	exit 0
    	;;
  esac
done

if [ -z "$PQNUMBER" ]; then
	echo "ERROR: Set pocket query number"
	exit -1
fi

if [ -z "$TYP" ]; then
	echo "ERROR: Set type tomtom or navigon"
	exit -1
fi

echo "Using pocket query ($PQNUMBER)"

if [ "$TYP" = "tomtom" ]; then
	unzip_files
  convert_tomtom2gpx
  remove_myfinds
  create_tomtomfile
elif [ "$TYP" = "navigon" ]; then
	unzip_files
  convert_tomtom2gpx
  remove_myfinds
  create_navigonfile
else
  echo "ERROR: Set type tomtom or navigon"
  exit -1
fi
