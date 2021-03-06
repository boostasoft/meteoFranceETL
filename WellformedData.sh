#! /bin/bash
# pour faire fonctionner correctement les scripts du bash, on a changé l'entete de /bin/sh a /bin/bash
PROJET=`pwd`

virgule=","
point="."
pointvirgule=","
slash="/"
drop="DROP TABLE meteoFrance."
cd ${PROJET}
mv Pub47 Pub47OLD

mkdir Pub47
cd Pub47
wget ftp://esurfmar.meteo.fr/pub/Pub47/PUB_47_export_esurfmar_database_active_vos_v3a.csv

wget ftp://esurfmar.meteo.fr/pub/Pub47/ALL_VOS_PFT_20141120_V04b.csv

wget ftp://esurfmar.meteo.fr/pub/Pub47/Pub_47_export_esurfmar_active_vosclim_v3b.csv

cd ..

ListeRep1="$(ls)"
for Rep1 in ${ListeRep1}, do
cd ${PROJET}
if [[ ! -e $Rep1 ]]
then
echo "Le fichier $Rep1 n existe pas !"
exit 1
fi
if [[ -d $Rep1 ]]
then
echo "Le fichier $Rep1 est un répertoire"
cd  ${PROJET}/$Rep1
ListeRep="$(ls)"
for Rep in ${ListeRep}, do
cd  ${PROJET}/$Rep1
base1=$(echo $Rep | cut -d"." -f1)
ext=$(echo $Rep | cut -d"." -f2)
dropfile=${drop}${Rep1}${point}${base1}${pointvirgule}
echo $dropfile >> ${PROJET}/lesCartesDeFrances.isql
done


contraint1="csv_registerD('"
contraint2="/root/dataResearch/meteoFrance/"
table="', '*.csv','MeteoFrance', '"
last="'),"
infotable=${contraint1}${PROJET}${slash}${Rep1}${table}${Rep1}${last}
chemin=${contraint2}${Rep1}${virgule}
exec="csv_loader_run(),"




echo $infotable >> ${PROJET}/lesCartesDeFrances.isql
echo $exec >> ${PROJET}/lesCartesDeFrances.isql
echo $chemin >> ${PROJET}/cheminAll
cd  /usr/bin/
# on a utilisé isql-v enfin de faire les commandes sql
isql-v    vps109217.ovh.net:1111  dba root  ${PROJET}/lesCartesDeFrances.isql
# nous avons aussi renseigné dans le fichier virtuoso.ini le repertoire Pub47 afin qu'il le prenne en compte.

rm ${PROJET}/lesCartesDeFrances.isql
rm ${PROJET}/cheminAll

fi

#rm ${PROJET}/lesCartesDeFrances.isql
#rm ${PROJET}/cheminAll

if [[ -f $Rep1 ]]
then
echo -n "Le fichier $Rep1 est un fichier ordinaire"
fi
done


