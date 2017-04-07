program Bataille_naval;

uses crt;

//constantes
CONST
	NbBateau=1;
	MaxCase=5;
	MinL=1;
	MaxL=50;
	MinC=1;
	MaxC=50;
	
//types
type Cases=record
	Ligne:integer;
	Col:integer;
end;

type Bateau=record
	nCase:array[1..MaxCase] Of Cases;
end;

type Flotte=record
	nBateau:array[1..NbBateau] Of Bateau;
end;

type PositionBateau=(Enligne,EnColonne,EnDiagonale);

type EtatBateau=(Toucher,Couler);

type EtatFlotte=(aFlot,aSombrer);

type EtatJoueur=(Gagne,Perd);

//fonctions et procedures
procedure CreateCases(l,c:integer;var nCases:Cases);
//BUT créer une case à partir de 2 coodonnées
//ENTREE ligne colonne
//SORTIE la case
BEGIN
	nCases.Ligne:=l;
	nCases.Col:=c;
END;

function CmpCases(nCases,tCases:Cases):boolean;
//BUT comparer 2 cases
//ENTREE les 2 cases
//SORTIE vrai si elle sont identiques
BEGIN
	IF (nCases.Col=tCases.Col) AND (nCases.Ligne=tCases.Ligne) THEN
		begin
			CmpCases:=True;
		end
	ELSE
		begin
			CmpCases:=False;
		end;
END;

function CreateBateau(nCases:Cases;Taille:integer):Bateau;
//BUT créer un bateau à partir d'une case et d'une taille
//ENTREE la case de départ et la taille du bateau
//SORTIE le bateau
VAR
	res:Bateau;
	i,pos:integer;
	posBateau:PositionBateau;
BEGIN
	randomize;
	pos:=random(3)+1;
	posBateau:=PositionBateau(pos);
	FOR i:=1 TO MaxCase DO
		begin
			IF i<=Taille THEN
				begin
					res.nCase[i].Ligne:=nCases.Ligne;
					res.nCase[i].Col:=nCases.Col;
				end
			ELSE
				begin
					res.nCase[i].Ligne:=0;
					res.nCase[i].Col:=0;
				end;
			IF (posBateau=EnLigne) THEN
				begin
					nCases.col:=nCases.Col+1;
				end
			ELSE
				begin
					IF (posBateau=EnColonne) THEN
						begin
							nCases.Ligne:=nCases.Ligne+1;
						end
					ELSE
						begin
							nCases.Col:=nCases.Col+1;
							nCases.Ligne:=nCases.Ligne+1;
						end;
				end;
		end;
	CreateBateau:=res;
END;

function ctrlCases(nbat:Bateau;nCases:Cases):boolean;
//BUT vérifier si une case appartient à un bateau
//ENTREE la case et le bateau
//SORTIE Vrai si la case appartient au bateau
VAR
	valtest:boolean;
    i:integer;
BEGIN
	valtest:=False;
	FOR i:=1 TO MaxCase DO
		begin
			IF (CmpCases(nBat.nCase[i],nCases)) THEN
				begin
					valtest:=True;
				end;
		end;
	ctrlCases:=valtest;
END;

function ctrlFlotte(nFlotte:Flotte;nCases:Cases):boolean;
//BUT vérifier si une case appartient à une flotte
//ENTREE la flotte et la case
//SORTIE vrai si la case appartient à la flotte
VAR
	i:integer;
	valtest:boolean;
BEGIN
	valtest:=False;
	FOR i:=1 TO NbBateau DO
		begin
			IF (ctrlCases(nFlotte.nBateau[i],nCases)) THEN
				begin
					valtest:=True;
				end;
		end;
	ctrlFlotte:=valtest;
END;

VAR
	i,j,x,y,taille,compteur,nbtour,batT:integer;
	nFlotte1,nFlotte2:Flotte;
	nCases:Cases;
	Ebat:EtatBateau;
	Eflotte:EtatFlotte;
	EJoueur:EtatJoueur;
	
BEGIN
	clrscr;
	//initialisation 
	nbtour:=0;
	Eflotte:=aFlot;
	EJoueur:=Perd;
	writeln('Init Flotte J1');
	FOR i:=1 TO NbBateau DO
		begin
			REPEAT
				randomize;
				x:=random(MaxC-MaxCase)+1;
				y:=random(MaxL-MaxCase)+1;
				CreateCases(x,y,nCases);
			UNTIL NOT ctrlFlotte(nFlotte1,nCases);
			taille:=random(MaxCase)+1;
			nFlotte1.nBateau[i]:=CreateBateau(nCases,taille);
		end;
	writeln('Appuyer sur entrer pour continuer');
	readln;
	writeln('Init Flotte J2');
	FOR i:=1 TO NbBateau DO
		begin
			REPEAT
				randomize;
				x:=random(MaxC-MaxCase)+1;
				y:=random(MaxL-MaxCase)+1;
				CreateCases(x,y,nCases);
			UNTIL NOT ctrlFlotte(nFlotte2,nCases);
			taille:=random(MaxCase)+1;
			nFlotte2.nBateau[i]:=CreateBateau(nCases,taille);
		end;
	writeln('Appuyer sur entrer pour continuer');
	readln;
	//jeu
	REPEAT
		//augmentation du nombre de tour
		nbtour:=nbtour+1;
		//réinitialisation de batT qui sert à vérifier si une case à été touchée
		batT:=0;
		//définition de quel joueur joue 
		IF nbtour MOD 2<>0 THEN
			begin
				writeln('Tour J1');
				//instructions permettant d'afficher les bateau adverse #
				{FOR i:=1 TO MaxCase DO
					begin
						writeln('Ligne',nFlotte2.nBateau[1].nCase[i].Ligne);
						writeln('Colonne',nFlotte2.nBateau[1].nCase[i].Col);
					end;}
				//saisi sécuriser d'une case à attaquer
				REPEAT
					writeln('Veuillez entrer une case');
					readln(x);
					readln(y);
				UNTIL (x<=MaxC) AND (x>0) AND (y>0) AND (y<=MaxL)
				CreateCases(x,y,nCases);
				//vérification de la case
				FOR i:=1 To NbBateau DO
					begin
						FOR j:=1 TO MaxCase DO
							begin
								IF CmpCases(nCases,nFlotte2.nBateau[i].nCase[j]) THEN
									begin
										//si touché on supprime la case et batT prend 1 pour retenir le fait que la case est touchée
										batT:=1;
										nFlotte2.nBateau[i].nCase[j].Ligne:=0;
										nFlotte2.nBateau[i].nCase[j].Col:=0;
										writeln('Toucher');
										//l'état du bateau passe en Toucher
										Ebat:=Toucher;
										//vérification de si le bateau est coulé
										compteur:=0;
										FOR x:=1 To MaxCase DO
											begin
												IF (nFlotte2.nBateau[i].nCase[x].Ligne=0) AND (nFlotte2.nBateau[i].nCase[x].Ligne=0) THEN
													begin
														compteur:=compteur+1;
													end;
											end;
										//si c'est le cas alors on vérifie si la flotte à sombrer
										IF compteur=MaxCase THEN
											begin
												compteur:=0;
												FOR x:=1 TO NbBateau DO
													begin
														FOR y:=1 TO MaxCase DO
															begin
																If (nFlotte2.nBateau[x].nCase[y].Ligne=0) AND (nFlotte2.nBateau[x].nCase[y].Ligne=0) THEN
																	begin
																		compteur:=compteur+1;
																	end;
															end;
													end;
											end;
										//si c'est le cas son état passe à aSombrer
										IF compteur=NbBateau*MaxCase THEN
											begin
												Eflotte:=aSombrer
											end;
									end;
							end;
					end;
				//si rien n'a été toucher alors on écrit rater
				IF batT=0 THEN
					begin
						writeln('Rater');
					end;
			end
		ELSE
			begin
				//idem pour le joueur 2
				writeln('Tour J2');
				//instructions permettant d'afficher les bateau adverse #
				{FOR i:=1 TO MaxCase DO
					begin
						writeln('Ligne',nFlotte1.nBateau[1].nCase[i].Ligne);
						writeln('Colonne',nFlotte1.nBateau[1].nCase[i].Col);
					end;}
				REPEAT
					writeln('Veuillez entrer une case');
					readln(x);
					readln(y);
				UNTIL (x<=MaxC) AND (x>0) AND (y>0) AND (y<=MaxL)
				CreateCases(x,y,nCases);
				FOR i:=1 To NbBateau DO
					begin
						FOR j:=1 TO MaxCase DO
							begin
								IF CmpCases(nCases,nFlotte1.nBateau[i].nCase[j]) THEN
									begin
										batT:=1;
										nFlotte1.nBateau[i].nCase[j].Ligne:=0;
										nFlotte1.nBateau[i].nCase[j].Col:=0;
										writeln('Toucher');
										Ebat:=Toucher;
										compteur:=0;
										FOR x:=1 To MaxCase DO
											begin
												IF (nFlotte1.nBateau[i].nCase[x].Ligne=0) AND (nFlotte1.nBateau[i].nCase[x].Ligne=0) THEN
													begin
														compteur:=compteur+1;
													end;
											end;
										IF compteur=MaxCase THEN
											begin
												compteur:=0;
												FOR x:=1 TO NbBateau DO
													begin
														FOR y:=1 TO MaxCase DO
															begin
																If (nFlotte1.nBateau[x].nCase[y].Ligne=0) AND (nFlotte1.nBateau[x].nCase[y].Ligne=0) THEN
																	begin
																		compteur:=compteur+1;
																	end;
															end;
													end;
											end;
										IF compteur=NbBateau*MaxCase THEN
											begin
												Eflotte:=aSombrer
											end;
									end;
							end;
					end;
				IF batT=0 THEN
					begin
						writeln('Rater');
					end;
			end;
		//Si la flotte a sombrer à la fin du tour alors un joueur a gagné
		IF Eflotte=aSombrer THEN
			begin
				EJoueur:=Gagne;
			end;
	//si un joueur a gagné alors on arrête la partie
	UNTIl EJoueur=Gagne;
	//on écrit quel joueur a gagné
	IF nbtour MOD 2<>0 THEN
		begin
			writeln(UTF8ToAnsi('Joueur 1 a gagné'));
		end
	ELSE
		begin
			writeln(UTF8ToAnsi('Joueur 2 a gagné'));
		end;
	readln;
END.