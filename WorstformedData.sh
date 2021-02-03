#! /bin/bash

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

old_IFS=$IFS     # sauvegarde du séparateur de champ  
IFS=$'\n'     # nouveau séparateur de champ, le caractère fin de ligne  
compteur=0
deux=2
un=1
trois=3
point_virgule=";"
virgule=","
espace=" "
undercore="_"
newDate="Date New"
mds="MDS"

cd  /usr/bin/
./isql-v vps109217.ovh.net dba root   ${PROJET}/cvs_register.isql

cd ${PROJET}
rm  -r ${PROJET}/baros/
mkdir -p ${PROJET}/baros/
cd  ${PROJET}/baros/
wget -r -np ftp://esurfmar.meteo.fr/pub/vos/baros/ &
wait
cd ${PROJET}
rm -r  ${PROJET}/datavos/
mkdir  -p ${PROJET}/datavos/
cd  ${PROJET}/datavos/
wget -r -np ftp://esurfmar.meteo.fr/pub/vos/data/ &
wait
cd ${PROJET}
rm   ${PROJET}/Pub47/
mkdir  -p ${PROJET}/Pub47/
cd  ${PROJET}/Pub47/
wget -np ftp://esurfmar.meteo.fr/pub/Pub47/PUB_47_export_esurfmar_database_active_vos_v3a.csv &
wait

wget -np ftp://esurfmar.meteo.fr/pub/Pub47/ALL_VOS_PFT_20141120_V04b.csv &
wait

wget -np ftp://esurfmar.meteo.fr/pub/Pub47/Pub_47_export_esurfmar_active_vosclim_v3b.csv &
wait

cd ${PROJET}
echo " le chelmin du projet"
echo ${PROJET}
#lister les repertoires et les fichiers du repertoire LesLivrablesMarines.

ListeRep="$(ls)"
echo  $ListeRep
if [[ $ListeRep == ' ' ]]
then
echo "Syntaxe d'appel :  nomFichier"
exit 1
fi

for Rep in ${ListeRep}
 do




if [[ -d $Rep ]]
then
echo "Le fichier $Rep est un répertoire"

#lecture du repertoire et changement de la disposition des
#contenus dans le fichier à transferer dans la base de données

####-------------------------Traitement des fichiers en fichiers MDS que virtuoso peut 
####intégrer--------------------------------------------------------------------------
echo "prochaine repertoire"
echo ${Rep} 
cd ${Rep} 
rm LEGENDE.csv
ListeFiles="$(ls)"

            
           for File in ${ListeFiles}
            do

            if [[ -f $File ]]
            then
            echo -n "Le fichier $File est un fichier ordinaire"
              if [[ -s $File  ]]
               then	
               echo " qui n'est pas vide"
               compteur=0
                sed -r -i -e "s/$point_virgule/$virgule/ig" ${File}  
                echo ${File}
                for ligne in $(cat $File)  
do  
   
   compteur=`expr "$compteur" + 1`
  # echo  $compteur
  if [[ $compteur -eq  $un ]] 
  then
    echo 'me voici au un'
  elif [[ $compteur -eq  $trois ]]  
  then 
    echo 'bonjour'
  else 
       if [[ $compteur -eq  $deux ]] 
       then
            #Extraire le nom du fichier sans extension csv..

           Encode=$(file $File | cut -d" " -f2)
           type=$(file $File | cut -d" " -f4)
            base=$(echo $File | cut -d"." -f1)
            ext=$(echo $File | cut -d"." -f2)

           STRING2=`awk 'END { print substr(sstr,8) }' "sstr=$ligne" /dev/null ` 
           # si length est omis la valeur substring va jusqu'à la fin

           ligne2=${newDate}${STRING2}
           name=${mds}${File} 
           echo $ligne2 | sed -e "s/ /_/g">> ${name} 
         
       else 
       echo $ligne >> ${name}  
      fi
  fi 
done  

#rm ${File}
               fi
           fi 

         done
echo "We do not treat or transfert a file directly"		 
#		 cd  /usr/bin/
#echo ${PROJET}/${Rep}.meteo_config.isql 
#./isql  localhost dba dba ${PROJET}/${Rep}.meteo_config.isql 
# il faut effectuer cette commande sinon le script ne saura pas quels sont les fichiers 
# du repertoire par rapport à ceux qui sont $ls
cd ${PROJET}
else
 echo "ce n'est pas un repertoire"
 echo `pwd`
 echo ${Rep}
cd ${PROJET}
fi
 done               

 # cette partie permet de réecrire la fonction qui permet de bien former les données météo.

virgule=","
point="."
pointvirgule=";"
slash="/"
drop="DROP TABLE meteoFrance."

cd ${PROJET}
ListeRep1="$(ls)"
for Rep1 in ${ListeRep1}; do
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
for Rep in ${ListeRep}; do
cd  ${PROJET}/$Rep1
base1=$(echo $Rep | cut -d"." -f1)
ext=$(echo $Rep | cut -d"." -f2)
dropfile=${drop}${Rep1}${point}${base1}${pointvirgule}
echo $dropfile >> ${PROJET}/lesCartesDeFrances.isql
done


contraint1="csv_registerD('"
table="', '*.csv','MeteoFrance', '"
last="');"
infotable=${contraint1}${PROJET}${slash}${Rep1}${table}${Rep1}${last}
chemin=${contraint2}${Rep1}${virgule}
exec="csv_loader_run();"




echo $infotable >> ${PROJET}/lesCartesDeFrances.isql
echo $exec >> ${PROJET}/lesCartesDeFrances.isql
echo $chemin >> ${PROJET}/cheminAll
cd  /usr/bin/
./isql-v  vps109217.ovh.net dba root ${PROJET}/lesCartesDeFrances.isql

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


