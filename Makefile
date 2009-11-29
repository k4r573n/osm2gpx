###############################################
#                                             #
# Makefile to create nice gpx files with POIs #
#                                             #
###############################################

#create a gpx-file from an osm-file

INPUT = post_box.osm
OSM_KEY = amenity
OSM_VALUE = post_box
OUTPUT = $(OSM_VALUE)
DEV=/dev/ttyUSB0

#location
LEFT = 10.492
BOTTOM = 52.2407
RIGHT = 10.5551
TOP = 52.2801

#Filter - lists all by default
FILTER1 = bla_irgendwas_das_nicht_als_key_vorkommt
INV_FILTER1 = yes
#filter2 = filter 1 ,because otherwise there is a wrong output if only filter1 is given
FILTER2 = $(FILTER1)
INV_FILTER2 = $(INV_FILTER1)


compile: $(OUTPUT).gpx

#nur bei parameter aufruf grafisch anzeigen
run: $(OUTPUT).gpx
	prune.sh $(OUTPUT).gpx

#alle meist genutzten ausgaben generieren
all: ic_pb ic_rest

send: $(OUTPUT).gpx
	#sendet die gpx datei auf das Garmin
	gpsbabel -i gpx,snlen=6 -o garmin,snlen=6 -f $(OUTPUT).gpx -F $DEV

$(OUTPUT).gpx: $(INPUT)
	xsltproc -o $(OUTPUT).gpx \
  	--stringparam osm_key $(OSM_KEY) \
  	--stringparam osm_value $(OSM_VALUE) \
  	--stringparam filter_key $(FILTER1) \
  	--stringparam invert_filter1 $(INV_FILTER1) \
  	--stringparam filter2_key $(FILTER2) \
  	--stringparam invert_filter2 $(INV_FILTER2) \
  	--stringparam dscr osm-waypoints \
	osm2gpx.xsl $(INPUT)

$(INPUT):
		wget -O "$(INPUT)" "http://www.informationfreeway.org/api/0.6/*[$(OSM_KEY)=$(OSM_VALUE)][bbox=$(LEFT),$(BOTTOM),$(RIGHT),$(TOP)]"

#oder http://osmxapi.hypercube.telascience.org/api/0.6/*[amenity=shop][bbox=10.492,52.254,10.5551,52.2801]

#incomplete post_boxes
ic_pb:
	[ -e post_box.gpx ] && rm post_box.gpx || echo ""
	make INPUT=post_box.osm FILTER1=collection_times INV_FILTER1=yes FILTER2=operator INV_FILTER2=yes

#incomplete restaurant
ic_rest:
	[ -e restaurant.gpx ] && rm restaurant.gpx || echo ""
	make INPUT=restaurant.osm OSM_VALUE=restaurant FILTER1=opening_hours INV_FILTER1=yes

#FILTER2=cuisine INV_FILTER2=no

#complete post_boxes - isnt really possible cause a node will be selected if filter1 or filter2 is true
c_pb:
	[ -e post_box.gpx ] && rm post_box.gpx || echo ""
	make INPUT=post_box.osm FILTER1=collection_times INV_FILTER1=no


input: $(INPUT)

edit:
	vim osm2gpx.xsl

clean:
	rm *.gpx
