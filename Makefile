INPUT = bs-pb.osm
#create a gpx-file from an osm-file
OSM_VALUE = post_box
OUTFILE = $(OSM_VALUE)


run: $(OUTFILE).gpx
	prune.sh $(OUTFILE).gpx

$(OUTFILE).gpx: $(INPUT)
	xsltproc -o $(OUTFILE).gpx \
  	--stringparam osm_key amenity \
  	--stringparam osm_value $(OSM_VALUE) \
  	--stringparam filter_key collection_times \
  	--stringparam invert_filter1 no \
  	--stringparam filter2_key collection_times \
  	--stringparam invert_filter2 no \
  	--stringparam dscr osm-waypoints \
	osm2gpx.xsl $(INPUT)

edit:
	vim osm2gpx.xsl

clean:
	rm *.gpx
