INPUT = bs-pb.osm
#create a gpx-file from an osm-file
OSM_KEY = amenity
OSM_VALUE = post_box
OUTFILE = $(OSM_VALUE)
DEV=/dev/ttyUSB0

#location
LEFT = 10.492
BOTTOM = 52.254
RIGHT = 10.5551
TOP = 52.2801

#Filter - listet standard mäßig alle auf
FILTER1 = bla_irgendwas_das_nicht_als_key_vorkommt^^
INV_FILTER1 = yes
FILTER2 = bla_irgendwas_das_nicht_als_key_vorkommt^^
INV_FILTER2 = yes


run: $(OUTFILE).gpx
	prune.sh $(OUTFILE).gpx

send: $(OUTFILE).gpx
	#sendet die gpx datei auf das Garmin
	gpsbabel -i gpx,snlen=6 -o garmin,snlen=6 -f $(OUTFILE).gpx -F $DEV

$(OUTFILE).gpx: $(INPUT)
	xsltproc -o $(OUTFILE).gpx \
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

edit:
	vim osm2gpx.xsl

clean:
	rm *.gpx
