// Akinator coded in Pascal by Luc PREVOST, 2017
program akinator;

uses crt {color,goto}, keyboard {read input}, sysutils {file};

const questionmax=10;
	persomax=10;
type tab1=array [1..persomax,1..questionmax] of string;
	tab2=array [1..questionmax] of string;

// Initialisation file
procedure initialisationfichier(var tabd:tab1; var nbrquestions,nbrpersonnages:integer);

var donnees:file of tab1;
	numperso:integer;

begin
	if not(FileExists('data_akinator.txt')) then
	Begin
		assign(donnees, 'data_akinator.txt');
		rewrite(donnees);
		tabd[1,1]:='                         ';
		{pour les questions}
		tabd[1,2]:='Is it a wooman ?        ';
		tabd[1,3]:='Is it a teacher ?       ';
		tabd[1,4]:='Does it has long hair ? ';
		tabd[1,5]:='Does it like running ?  ';
		nbrquestions:=4;
		{pour les personnages}
		numperso:=2;
		tabd[numperso,1]:='Lisa';
		tabd[numperso,2]:='yes';
		tabd[numperso,3]:='yes';
		tabd[numperso,4]:='no';
		tabd[numperso,5]:='no';
		numperso:=3;
		tabd[numperso,1]:='Jason';
		tabd[numperso,2]:='no';
		tabd[numperso,3]:='no';
		tabd[numperso,4]:='yes';
		tabd[numperso,5]:='no';
		numperso:=4;
		tabd[numperso,1]:='Yassine';
		tabd[numperso,2]:='no';
		tabd[numperso,3]:='no';
		tabd[numperso,4]:='no';
		tabd[numperso,5]:='no';
		numperso:=5;
		tabd[numperso,1]:='Claire';
		tabd[numperso,2]:='yes';
		tabd[numperso,3]:='yes';
		tabd[numperso,4]:='yes';
		tabd[numperso,5]:='yes';
		numperso:=6;
		tabd[numperso,1]:='Luc';
		tabd[numperso,2]:='no';
		tabd[numperso,3]:='no';
		tabd[numperso,4]:='no';
		tabd[numperso,5]:='yes';
		nbrpersonnages:=numperso-1;
		write(donnees,tabd);
		close(donnees);
	end
	else
	begin{for nbrpersonnages}
		assign(donnees, 'data_akinator.txt');
		reset(donnees);
		read(donnees,tabd);
		numperso:=1;
		repeat
			numperso:=numperso+1;
		until (tabd[numperso,2]<>'yes') and (tabd[numperso,2]<>'no');
		nbrpersonnages:=numperso-2;
		close(donnees);
		nbrquestions:=4;{for nbrquestion}
	end;
end;

// Game iteration
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
	assign(donnees, 'data_akinator.txt');
	reset(donnees);
	read(donnees, tabd);
	writeln(tabd[1,x+1]);
	close(donnees);
	writeln('');
	writeln('Yes          [ ]');
	writeln('No           [ ]');
	writeln('I don t know [ ]');
	writeln('');
	writeln('*Type SPACE BAR to select*');
	pos:=wherey;
	gotoxy(15,pos-5);
	InitKeyBoard();
	repeat
		K:=GetKeyEvent();
		K:=TranslateKeyEvent(K);
		if (KeyEventToString(K) = 'Up') and (wherey>pos-5) then
			GotoXY(15,wherey-1);
		if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then
			GotoXY(15,wherey+1);
	until KeyEventToString(K) = ' ';
	c:=wherey;
	DoneKeyBoard();
	if c=pos-5 then tabr[x]:='yes';
	if c=pos-4 then tabr[x]:='no';
	if c=pos-3 then tabr[x]:='nsp';
end;

// Research character
procedure recherchepersonnage(tabr:tab2; nbrquestions:integer; nbrpersonnages:integer; var victoire:boolean; var retour:integer);

var i,j,c,pos:integer;
	k:TKeyEvent;
	personnage:string;
	tabd:tab1;
	donnees:file of tab1;

begin
	gotoxy(1,9);
	assign(donnees, 'data_akinator.txt');
	reset(donnees);
	read(donnees, tabd);
	i:=1;
	j:=1;
	repeat
		i:=i+1;
		victoire:=true;
		for j:=2 to nbrquestions+1 do if tabr[j-1]<>tabd[i,j] then
			victoire:=false;
	until (victoire=true) or (i=nbrpersonnages+1);
	close(donnees);
	
	if victoire=true then
	begin
		personnage:=tabd[i,1];
		writeln('I think at ... ',personnage,' !');
		writeln('');
		writeln('Menu [ ]');
		writeln('Exit [ ]');
		writeln('');
		writeln('*Type SPACE BAR to select*');
		pos:=wherey;
		gotoxy(7,pos-4);
		InitKeyBoard();
		repeat
			K:=GetKeyEvent();
			K:=TranslateKeyEvent(K);
			if (KeyEventToString(K) = 'Up') and (wherey>pos-4) then
				GotoXY(7,wherey-1);
			if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then
				GotoXY(7,wherey+1);
		until (KeyEventToString(K) = ' ');
		c:=wherey;
		DoneKeyBoard();
		if (c=pos-4) then retour:=1;
		if (c=pos-3) then retour:=0;
	end
	else 
	begin
		writeln('I don t find your character ...');
		writeln('');
		writeln('Add wharacter [ ]');
		writeln('Menu          [ ]');
		writeln('Exit          [ ]');
		writeln('');
		writeln('*Type SPACE BAR to select*');
		pos:=wherey;
		gotoxy(16,pos-5);
		InitKeyBoard();
		repeat
			K:=GetKeyEvent();
			K:=TranslateKeyEvent(K);
			if (KeyEventToString(K) = 'Up') and (wherey>pos-5) then
				GotoXY(16,wherey-1);
			if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then
				GotoXY(16,wherey+1);
		until KeyEventToString(K) = ' ';
		c:=wherey;
		DoneKeyBoard();
		
		if c=pos-5 then
		begin
			gotoxy(1,16);
			nbrpersonnages:=nbrpersonnages+2;
			write('What is his name ? ');
			repeat
				readln(personnage);
			until personnage<>'';
			assign(donnees, 'data_akinator.txt');
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

// Display data table
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

// Rules
procedure regles (var retour:integer);

var pos,c:integer;
	K:TKeyEvent;

begin
	clrscr;
	writeln('The purpose it to make Akinator find your character answering questions.');
	writeln('You can edit them in the data base.');
	writeln('');
	writeln('Menu [ ]');
	writeln('Exit [ ]');
	writeln('');
	writeln('*Type SPACE BAR to select*');
	pos:=wherey;
	gotoxy(7,pos-4);
	c:=1;
	InitKeyBoard();
	repeat
		K:=GetKeyEvent();
		K:=TranslateKeyEvent(K);
		if (KeyEventToString(K) = 'Up') and (wherey>pos-4) then	GotoXY(7,wherey-1);
		if (KeyEventToString(K) = 'Down') and (wherey<pos-3) then GotoXY(7,wherey+1);
		
	until KeyEventToString(K) = ' ';
	c:=wherey;
	DoneKeyBoard();
	if c=pos-4 then retour:=1;
	if c=pos-3 then retour:=0;
end;

// Menu
procedure menu(var gojeu,gobdd,goregles:boolean);

var c:integer;
	K:TKeyEvent;

Begin
	InitKeyBoard();
	gojeu:=false;
	gobdd:=false;
	goregles:=false;
	writeln('Akinator by Luc PREVOST');
	writeln('');
	writeln('Play      [ ]');
	writeln('Data base [ ]');
	writeln('Rules     [ ]');
	writeln('');
	writeln('*Type SPACE BAR to select*');
	gotoxy(12,3);
	
	repeat
		K:=GetKeyEvent();
		K:=TranslateKeyEvent(K);
		if (KeyEventToString(K) = 'Up') and (wherey>3) then
			GotoXY(12,wherey-1);
		if (KeyEventToString(K) = 'Down') and (wherey<5)then
			GotoXY(12,wherey+1);
		c:=wherey;
	until KeyEventToString(K) = ' ';
	
	DoneKeyBoard();
	case c of
		3:gojeu:=true;
		4:gobdd:=true;
		5:goregles:=true;
	end;
End;

// Data base
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
	writeln('*Type SPACE BAR to select*');
	pos:=wherey;
	gotoxy(7,pos-4);
	InitKeyBoard();
	repeat
		K:=GetKeyEvent();
		K:=TranslateKeyEvent(K);
		if (KeyEventToString(K) = 'Up') and (wherey>pos-4) then
			GotoXY(7,wherey-1);
		if (KeyEventToString(K) = 'Down') and (wherey<pos-3)then
			GotoXY(7,wherey+1);
		c:=wherey;
	until KeyEventToString(K) = ' ';
	
	DoneKeyBoard();
	if c=pos-4 then retour:=1;
	if c=pos-3 then retour:=0;
end;

// Game
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

// Main
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
