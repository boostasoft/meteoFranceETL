#! /bin/sh
PROJET=`pwd`
# L'interet de ce shell est de permettre la segmentation et le deployement
# des fichiers sous formes des données xml généréees par yatea
#La principale difficulté est l'encodage des chaines des caracteres
#Ce script permet de recuperer les librables placés dans repertoires et
#un contenu xml de yatea... Nous avons opté de faire un  flemmatisation des contenus treetagger
#avant des transmettre a yatea.
# & wait permet d'attendre la fin du processus afin d'executer la suivante.
# Le todo consistera à mettre ces contenus dans un repertoire temporaire afin
# afin d'assurer la destruction des repertoire  a tout moment...
#version du 01/05/2011...
# Il est difficile de lire tous mes .000 du format
# s57... le fichier marche pour un document s57...
# placé dans  datas57....
#cd ${PROJET}/datas57/
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

