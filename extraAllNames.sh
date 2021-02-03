#! /bin/sh
PROJET=`pwd`

virgule=","

cd ${PROJET}/datas57/
ListeRep="$(ls)"
for Rep in ${ListeRep}; do
base1=$(echo $Rep | cut -d"." -f1)
ext=$(echo $Rep | cut -d"." -f2)
contraint1="csv_registerD('"
contraint2="/home/dieudonne/Theses/Projet_Forge_Navigation/dataResearch/csv/"
table="', '*.csv','CarteFrance', '"
last="');"
infotable=${contraint1}${contraint2}${base1}${table}${base1}${last}
chemin=${contraint2}${base1}${virgule}
exec="csv_loader_run();"

rm ${PROJET}/lesCartesDeFrances.isql
rm ${PROJET}/cheminAll
echo $infotable >> ${PROJET}/lesCartesDeFrances.isql
echo $exec >> ${PROJET}/lesCartesDeFrances.isql
echo $chemin >> ${PROJET}/cheminAll


cd  /usr/bin/
echo ${PROJET}/${Rep}.meteo_config.isql 
./isql  localhost dba dba ${PROJET}/lesCartesDeFrances.isql

done

