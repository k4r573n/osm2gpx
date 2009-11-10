#!/bin/bash

INPUT="bs-pb.osm"

#create a gpx-file from an osm-file
OUTFILE="./post_box.gpx"

xsltproc -o $OUTFILE \
	--stringparam osm_key amenity \
	--stringparam osm_value post_box \
	--stringparam filter_key collection_times \
	--stringparam invert_filter1 yes \
	--stringparam filter2_key operator \
	--stringparam invert_filter2 yes \
	--stringparam dscr osm-waypoints \
	osm2gpx.xsl $INPUT
echo "$OUTFILE"

