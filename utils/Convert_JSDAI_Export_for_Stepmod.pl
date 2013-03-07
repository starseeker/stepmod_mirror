=head1 NOM

Programme I<ModifXML> - Programme de modification des fichiers xml et gif relatifs à un module.

=head1 SYNOPSIS

C<perl ModifXML.pl path_to_folder_containing_the_xml_and_gif>

=head1 DESCRIPTION

Ce programme a pour vocation de traiter les fichiers xml et gifs générés par jsdai afin de les adapter aux différentes contraintes liées à l'environnement dans lequel ces fichiers sont utilisés.
Pour se faire, diverses questions sont posées à l'utilisateur pour le guider dans le processus de modification des fichiers xml et gif.
L'ensemble des modifications sont appliquées sur les copies des fichiers sources regroupés dans un dossier au nom du module et le tout, placé dans le répertoire courant.

La documentation est réalisée avec B<Pod>.

=head2 Fonctions

=over 4

=item xml($fichierxml)

	Cette fonction prend en paramètre un fichier xml et lui applique diverses modifications en vue de l'adapter aux contraintes définies par l'utilisateur.

=over 8

=item Input

	Un fichier xml.

=item Output

	Une copie modifiée du fichier xml d'origine, placée dans le répertoire courant dans un dossier portant le nom du module spécifié.

=back

=item main()
	
	Le corps du programme présent dans le main consiste à récupérer les informations nécessaires au traitement auprès de l'utilisateur. 
	Une fois les informations récupérées, les fichiers modifiés sont placés dans un dossier au nom du module et placé dans le repertoire courant.

=over 6


=item Input

	Rien.

=item Output

	Un un dossier portant le nom du module spécifié et contenant l'ensemble des gif et xml modifiés.

=item Questions posées et réponses attendues

B<Entrez le nom du module a modifier tel qu'il apparait dans les fichiers xml>

Nom du module présent dans les fichiers xml et qui nécessite une modification.

Exemple: <img.area shape="rect" coords="371,222,425,301" href="../../resources/ap242_bo_model/ap242_bo_model.xml#ap242_bo_model.part" />

->Recopier "ap242_bo_model"

B<Entrez le nom du module tel qu'il doit apparaitre apres modification>

Nom qui doit remplacer celui specifie precedemment

Exemple: ap242_business_object_model

B<Entrez le nom du schema tel qu'il doit apparaitre apres modifications>

Nom qui doit remplacer le nom du schema inscrit dans les xml

Exemple: Ap242_business_object_model_arm

B<Entrez le nom generique des fichiers xml et gif a modifier (armexpg, mimexpg, bomexpg, modelexpg...)>

Partie commune des noms des fichiers xml et gif a modifier

Exemple: armexpg1.xml armexpg2.xml Imagearmexpg1.gif Imagearmexpg2.gif

->Entrer "armexpg"

B<Voulez-vous conserver des noms de fichiers identiques aux originaux?(oui/non)>

Donner aux fichiers modifiés le même nom que les originaux ou choisir un autre nom?

B<Entrez le nom generique desire pour le nommage des fichiers>

Nom donné aux fichiers modifiés. Ces fichiers conserveront néanmoins les mêmes numéros (s'ils en ont un) que les fichiers d'origine.

Exemple: armexpg1.xml armexpg2.xml Imagearmexpg1.gif Imagearmexpg2.gif verront leurs copies modifiés s'appeler exp1.xml exp2.xml exp1.gif exp2.gif si l'utilisateur choisi le nom "exp"

=back

=back

=head1 AUTEUR

Mickaël Francisco, Boost-Conseil

L<http://www.boost-conseil.com/>

=head1 VOIR AUSSI

L<Retour en haut de page |/"NOM">

=cut

 


use File::Copy;

main();

sub xml {
	my $fichier=$_[0];
	$fichier =~ /\/(\w*).xml/;
	$nomfichierxml=$1;
	my $nomTemp = $nomchoisi;
	if($nomTemp ne ""){ #Si un nom a été défini pour la création des fichiers le nom qui sera utilisé sera celui-ci suivie du numéro correspondant au fichier initiale
		$fichier =~ /(\d*).xml/;
		$nomfichierxml=$nomTemp.$1;
	}else{
		$fichier =~ /\/(\w*?)\d*.xml/;
		$nomTemp = $1 ;
	}
	
	open( XML, "< $fichier") or die "not possible to open : $fichier!";	
	open( TEMP, "> ./$NomModule/$nomfichierxml.xml") or die "not possible to open : $xml$nomfichierxml.xml!\n";	
		
	while(<XML>){
		$lignecourante=$_; #Sauvegarde de la ligne courante pour la réutiliser par la suite
		$NomModuleMin=lc($NomModule);
		#$NomSchema=ucfirst($NomModule);
		$NomSchema=lc($Schema);
		
		#Modifications apportées au fichier xml pour correspondre a l'architecture désirée
		if($lignecourante =~ m/^<img.area shape="rect" (.*)href="(.*)\.[^\.]*/i) #m/^<img.area shape="rect" (.*)href="(.*)?_?[^\_]*\.[^\.]*/i
		{
			$motifposthref=$2;
			if($motifposthref =~ m/(.*)_arm|_bom|_mim/i){
				$motifposthref=$1;
			}
			if($motifposthref =~ m/\#$NomOrigine/i){
				#print "$motifposthref et $NomOrigine cas 1\n";
				$lignecourante =~ s/$motifposthref/..\/$NomModuleMin\/sys\/4_info_reqs.xml\#$NomSchema/;
			}else{
				$motifposthref =~ /\#(\w*)/;
				#print "$motifposthref et $NomOrigine cas 2\n";
				$nomSchemaExterne=$1;
				$nomSchemaExterneMin =lc($1);
				$lignecourante =~ s/$motifposthref/..\/$nomSchemaExterneMin\/sys\/4_info_reqs.xml\#$nomSchemaExterne/;
			}
		#MODIF du 03/2013 :
		}elsif($lignecourante =~ m/^<\?xml-stylesheet type="text\/xsl" href="(.*)"\?>/)
		{
			if(($ModuleOuBOM eq "o") or ($ModuleOuBOM eq "oui") or ($ModuleOuBOM eq "yes") or ($ModuleOuBOM eq "y")){ 
				$lignecourante =~ s/$1/..\/..\/..\/xsl\/bom_doc\/imgfile.xsl/;
			}else{
				$lignecourante =~ s/$1/..\/..\/..\/xsl\/imgfile.xsl/;
			}
		}elsif($lignecourante =~ m/^<\!DOCTYPE imgfile.content SYSTEM "(.*)">/)
		{
			if(($ModuleOuBOM eq "o") or ($ModuleOuBOM eq "oui") or ($ModuleOuBOM eq "yes") or ($ModuleOuBOM eq "y")){ 
				$lignecourante =~ s/$1/..\/..\/..\/dtd\/bom_doc\/text.ent/;
			}else{
				$lignecourante =~ s/$1/..\/..\/..\/dtd\/text.ent/;
			}
		}elsif($lignecourante =~ m/^<imgfile.content (.*)/)
		{
			if(($ModuleOuBOM eq "o") or ($ModuleOuBOM eq "oui") or ($ModuleOuBOM eq "yes") or ($ModuleOuBOM eq "y")){
				$lignecourante =~ s/$1/business_object_model="$NomModuleMin" file="$nomfichierxml.xml">/;
			}else{
				$lignecourante =~ s/$1/module="$NomModuleMin" file="$nomfichierxml.xml">/;
			}
		#FIN MODIF.
		}elsif($lignecourante =~ m/^<img src="(.*)">/)
		{
			$lignecourante =~ s/$1/$nomfichierxml.gif/;
		}elsif($lignecourante =~ m/^<img.area shape="poly" (.*)\/(\w*expg)\d*.xml" \/>/)
		{
			$lignecourante =~ s/$2/$nomTemp/;
			#print "nomTemp: $nomTemp\n";
		}
		print TEMP $lignecourante or die "Pas possible d ecrire\n";
	}
	close(XML);
	close(TEMP);
}

sub main(){
		$nomchoisi="";
		$xml=$ARGV[0];
		
		print "S'agit-il d'un BOM (et non d'un module)? (oui/non):\n"; #MODIF du 03/2013 : demander ici s'il s'agit d'un module ou d'un BOM
		$ModuleOuBOM=<STDIN>;
		chop $ModuleOuBOM;
		
		print "Entrez le nom du module a modifier tel qu'il apparait dans les fichiers xml:\n";
		$NomOrigine=<STDIN>;
		chop $NomOrigine;
		
		print "Entrez le nom du module tel qu'il doit apparaitre apres modification:\n";
		$NomModule=<STDIN>;
		chop $NomModule;
		
		print "Entrez le nom du schema tel qu'il doit apparaitre apres modifications:\n";
		$Schema=<STDIN>;
		chop $Schema;
		
		print "Entrez le nom generique des fichiers xml et gif a modifier (armexpg, mimexpg, bomexpg, modelexpg...)\n";
		$type=<STDIN>;
		chop $type;
		$type=$type;
		
		#Code permettant la création du dossier d'exports des fichiers xml et gif
		if(mkdir "./$NomModule", 0755)
		{
			print("Dossier ./$NomModule créé avec succès\n");
		}else
		{
			if(-d $outputDir)
			{
				print "Le répertoire ./$NomModule existe\n";
			}else
			{
				print("Impossible de créer ./$NomModule\n");
			}
		}
		
		print"Voulez-vous conserver des noms de fichiers identiques aux originaux? (oui/non)\n";
		$rep=<STDIN>;
		chop $rep; #Enleve à la variable $rep le dernier caractère (ici le caractère d'aquitement final)
		if(($rep eq "n") or ($rep eq "non") or ($rep eq "no")){ 
			print"Entrez le nom generique desire pour le nommage des fichiers\n";
			$nomchoisi=<STDIN>;
			chop $nomchoisi; #Enleve à la variable $nomchoisi le dernier caractère (ici le caractère d'aquitement final)
		}
		@listexml=glob("$xml/*.xml"); #Stock dans une liste l'ensemble des fichiers xml du répertoire spécifié en paramètre
		foreach (@listexml){ #Pour chaque fichier, le traitement est effectué
			#print "$_\n";
			if($_=~ /\/.*$type.*\.xml/){
				xml($_);
			}
		}
		@listegif=glob("$xml/*.gif"); #Stock dans une liste l'ensemble des fichiers gif du répertoire spécifié en paramètre
		foreach $i(@listegif){ #On copie chaque fichier en le renommant comme le fichier xml auquel il fait reference
			#print "$i\n";
			if($i=~ /\/.*$type.*\.gif/){
				if($nomchoisi eq ""){
					$i=~ /\/(\w*.gif)/;
					$nomGif=$1;
				}else{
					$i =~ m/(\d*)\.gif/;
					$nomGif=$nomchoisi.$1.".gif";
				}
				copy($i,"./$NomModule/$nomGif");
			}
			
		}
		print "Modifications effectuees avec succes\n";
}