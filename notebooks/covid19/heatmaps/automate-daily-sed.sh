#!/usr/bin/env bash
#
MYDATE=$1
#
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Regional-${MYDATE}-pred07Days-displayFuelBigData.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Regional-${MYDATE}-pred14Days-displayFuelBigData.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Regional-${MYDATE}-pred21Days-displayFuelBigData.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Regional-${MYDATE}-pred42Days-displayFuelBigData.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Regional-${MYDATE}-pred63Days-displayFuelBigData.html
#
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Global-${MYDATE}-pred7Days.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Global-${MYDATE}-pred14Days.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Global-${MYDATE}-pred21Days.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Global-${MYDATE}-pred42Days.html
bash -x sed-format-fit-website-Copy2.sh Heatmap_Folium-Global-${MYDATE}-pred63Days.html
#
mv Heatmap_Folium-Global-${MYDATE}-pred7Days.html-e Heatmap_Folium-Global-YYYY-MM-DD-pred07Days.html 
mv Heatmap_Folium-Global-${MYDATE}-pred14Days.html-e Heatmap_Folium-Global-YYYY-MM-DD-pred14Days.html 
mv Heatmap_Folium-Global-${MYDATE}-pred21Days.html-e Heatmap_Folium-Global-YYYY-MM-DD-pred21Days.html 
mv Heatmap_Folium-Global-${MYDATE}-pred42Days.html-e Heatmap_Folium-Global-YYYY-MM-DD-pred42Days.html 
mv Heatmap_Folium-Global-${MYDATE}-pred63Days.html-e Heatmap_Folium-Global-YYYY-MM-DD-pred63Days.html 
#
