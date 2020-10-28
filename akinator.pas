program akinator;

uses crt {couleur,goto}, keyboard {lire une touche}, sysutils {fichier};

const questionmax=10;
	persomax=10;
type tab1=array [1..persomax,1..questionmax] of string;
	tab2=array [1..questionmax] of string;



procedure initialisationfichier(var tabd:tab1; var nbrquestions,nbrpersonnages:integer);

var donnees:file of tab1;
	numperso:integer;

begin
if not(FileExists('fichierdonnees')) then
Begin
assign(donnees, 'fichierdonnees');
rewrite(donnees);
tabd[1,1]:='                           ';
{pour les questions}
tabd[1,2]:='Est-ce une femme ?         ';
tabd[1,3]:='Est-ce un prof ?           ';
tabd[1,4]:='A-t-il les cheveux longs ? ';
tabd[1,5]:='Cours-t-il dimanche ?      ';
nbrquestions:=4;
{pour les personnages}
numperso:=2;
tabd[numperso,1]:='Un prof d info';
	tabd[numperso,2]:='non';
	tabd[numperso,3]:='oui';
	tabd[numperso,4]:='non';
	tabd[numperso,5]:='non';
numperso:=3;
tabd[numperso,1]:='Jason';
	tabd[numperso,2]:='non';
	tabd[numperso,3]:='non';
	tabd[numperso,4]:='oui';
	tabd[numperso,5]:='non';
numperso:=4;
tabd[numperso,1]:='Yassine';
	tabd[numperso,2]:='non';
	tabd[numperso,3]:='non';
	tabd[numperso,4]:='non';
	tabd[numperso,5]:='non';
numperso:=5;
tabd[numperso,1]:='Claire';
	tabd[numperso,2]:='oui';
	tabd[numperso,3]:='oui';
	tabd[numperso,4]:='oui';
	tabd[numperso,5]:='oui';
numperso:=6;
tabd[numperso,1]:='Luc';
	tabd[numperso,2]:='non';
	tabd[numperso,3]:='non';
	tabd[numperso,4]:='non';
	tabd[numperso,5]:='oui';
nbrpersonnages:=numperso-1;
write(donnees,tabd);
close(donnees);
end
else
begin{pour nbrpersonnages}
assign(donnees, 'fichierdonnees');
reset(donnees);
read(donnees,tabd);
numperso:=1;
repeat
numperso:=numperso+1;
until (tabd[numperso,2]<>'oui') and (tabd[numperso,2]<>'non');
nbrpersonnages:=numperso-2;
close(donnees);
nbrquestions:=4;{pour nbrquestion}
end;
end;



procedure tourdejeu(nbrquestions:integer; var tabr:tab2);

var tabd:tab1;
	x,c,pos:integer;
	K:TKeyEvent;
	donnees:file of tab1;
begin
clrscr;
randomize;
repeat
x:=random(nbrquestions+1);
until tabr[x]='0';
assign(donnees, 'fichierdonnees');
reset(donnees);
read(donnees, tabd);
writeln(tabd[1,x+1]);
close(donnees);
writeln('');
writeln('OUI            [ ]');
writeln('NON            [ ]');
writeln('Je ne sais pas [ ]');
writeln('');
writeln('Entrer ESPACE pour selectioner.');
pos:=wherey;
gotoxy(17,pos-5);
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>pos-5) then	GotoXY(17,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then GotoXY(17,wherey+1);
until KeyEventToString(K) = ' ';
c:=wherey;
DoneKeyBoard();
if c=pos-5 then tabr[x]:='oui';
if c=pos-4 then tabr[x]:='non';
if c=pos-3 then tabr[x]:='nsp';
end;



procedure recherchepersonnage(tabr:tab2; nbrquestions:integer; nbrpersonnages:integer; var victoire:boolean; var retour:integer);

var i,j,c,pos:integer;
	k:TKeyEvent;
	personnage:string;
	tabd:tab1;
	donnees:file of tab1;

begin
gotoxy(1,9);
assign(donnees, 'fichierdonnees');
reset(donnees);
read(donnees, tabd);
i:=1;
j:=1;
repeat
i:=i+1;
victoire:=true;
for j:=2 to nbrquestions+1 do if tabr[j-1]<>tabd[i,j] then victoire:=false;
until (victoire=true) or (i=nbrpersonnages+1);
close(donnees);

if victoire=true then
begin
personnage:=tabd[i,1];
writeln('Je pensse a ... ',personnage,' !');
writeln('');
writeln('Menu   [ ]');
writeln('Quiter [ ]');
writeln('');
writeln('Touche ESPACE pour selectioner.');
pos:=wherey;
gotoxy(9,pos-4);
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>pos-4) then	GotoXY(9,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then GotoXY(9,wherey+1);
until (KeyEventToString(K) = ' ');
c:=wherey;
DoneKeyBoard();
if (c=pos-4) then retour:=1;
if (c=pos-3) then retour:=0;
end

else 
begin
writeln('Je ne trouve pas ton personnage.');
writeln('');
writeln('Je veux le rajouter [ ]');
writeln('Menu                [ ]');
writeln('Quiter              [ ]');
writeln('');
writeln('Touche ESPACE pour selectioner.');
pos:=wherey;
gotoxy(22,pos-5);
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>pos-5) then	GotoXY(22,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then GotoXY(22,wherey+1);
until KeyEventToString(K) = ' ';
c:=wherey;
DoneKeyBoard();

if c=pos-5 then
begin
gotoxy(1,16);
nbrpersonnages:=nbrpersonnages+2;
write('quel est son nom ? ');
repeat
readln(personnage);
until personnage<>'';
assign(donnees, 'fichierdonnees');
reset(donnees);
read(donnees,tabd);
rewrite(donnees);
tabd[nbrpersonnages,1]:=personnage;
for i:=2 to nbrquestions+1 do tabd[nbrpersonnages,i]:=tabr[i-1];
write(donnees,tabd);
close(donnees);
retour:=1;
end;
if c=pos-4 then retour:=1;
if c=pos-3 then retour:=0;
end
end;



procedure affichagetabd(tabd:tab1;nbrpersonnages,nbrquestions:integer);

var i,j:integer;

begin
clrscr;
for j:=1 to nbrquestions+1 do
for i:=1 to nbrpersonnages+1 do
begin
if j=1 then textcolor(red);
if i=1 then textcolor(green);
if i=nbrpersonnages+1 then writeln(tabd[i,j]) else write(tabd[i,j],' / ');
textcolor(white);
end;
end;



procedure regles (var retour:integer);

var pos,c:integer;
	K:TKeyEvent;

begin
clrscr;
writeln('Le but est de faire trouver un personnage de l INSA a Akinator.');
writeln('');
writeln('Menu   [ ]');
writeln('Quiter [ ]');
writeln('');
writeln('Touche ESPACE pour selectioner.');
pos:=wherey;
gotoxy(9,pos-4);
c:=1;
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>pos-4) then	GotoXY(9,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<pos-3) then GotoXY(9,wherey+1);

until KeyEventToString(K) = ' ';
c:=wherey;
DoneKeyBoard();
if c=pos-4 then retour:=1;
if c=pos-3 then retour:=0;
end;



procedure menu(var gojeu,gobdd,goregles:boolean);

var c:integer;
	K:TKeyEvent;

Begin
InitKeyBoard();
gojeu:=false;
gobdd:=false;
goregles:=false;
writeln('Aquinator par NINJA7V');
writeln('');
writeln('Jouer          [ ]');
writeln('base de donnee [ ]');
writeln('Regles         [ ]');
writeln('');
writeln('Touche ESPACE pour selectioner.');
gotoxy(17,3);

repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>3) then	GotoXY(17,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<5)then GotoXY(17,wherey+1);
c:=wherey;
until KeyEventToString(K) = ' ';

DoneKeyBoard();
if c=3 then gojeu:=true;
if c=4 then gobdd:=true;
if c=5 then goregles:=true;
End;



procedure bdd(var retour:integer);

var tabd:tab1;
	nbrquestions,nbrpersonnages,pos,c:integer;
	K:TKeyEvent;

begin
initialisationfichier(tabd,nbrquestions,nbrpersonnages);
affichagetabd(tabd,nbrpersonnages,nbrquestions);
writeln('');
writeln('Menu [ ]');
writeln('Exit [ ]');
writeln('');
writeln('Touche ESPACE pour selectioner.');
pos:=wherey;
gotoxy(7,pos-4);
InitKeyBoard();
repeat
K:=GetKeyEvent();
K:=TranslateKeyEvent(K);
if (KeyEventToString(K) = 'Up') and (wherey>pos-4) then	GotoXY(7,wherey-1);
if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then GotoXY(7,wherey+1);
c:=wherey;
until KeyEventToString(K) = ' ';

DoneKeyBoard();
if c=pos-4 then retour:=1;
if c=pos-3 then retour:=0;
end;



procedure jeu(var retour:integer);

var victoire:boolean;
	nbrquestions,nbrpersonnages,i:integer;
	tabd:tab1;
	tabr:tab2;

begin
initialisationfichier(tabd,nbrquestions,nbrpersonnages);
for i:=1 to questionmax do tabr[i]:='0';
victoire:=false;
for i:=1 to nbrquestions do tourdejeu(nbrquestions,tabr);
recherchepersonnage(tabr,nbrquestions,nbrpersonnages,victoire,retour);
end;



// programe principal

var gojeu,gobdd,goregles:boolean;
	retour:integer;

begin
repeat
clrscr;
menu(gojeu,gobdd,goregles);
if goregles=true then regles(retour);
if gobdd=true then bdd(retour);
if gojeu=true then jeu(retour);
until retour=0;
end.
