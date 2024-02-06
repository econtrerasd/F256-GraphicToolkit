10    peekloc=alloc(1):mousespeed#=0.60:prop=0:tx=20:ty=15:lay=1:px=1:py=015    rows=alloc(40)20    dim p$(10):colsh=1:cls :tilesoff()25    for c=0 to 7:p$(c)="----------":next 30    sprites on :poke $D000,63:rem "Enable bmp, spr, tiles"40    loadpalette("default",0)50    defspr():bitmap on :bitmap clear 0:cls 60    sprite 1 to 84,196 image 063    sprite 0 to 100,100 image 165    sprite 2 to 69,235 image 270    rect solid 0,188 color 3 to 319,23975    rect solid 49,192 color 252 to 79,23980    rect solid 80,192 color 242 to 319,23990    drawnexticon(0,192,245)100   drawnexticon(17,208,243)110   drawnexticon(0,208,245)120   drawnexticon(0,224,245)130   drawnexticon(17,224,243)140   drawnexticon(48,208,7)150   drawnexticon(64,224,241)160   drawnexticon(64,208,241)170   drawnexticon(64,192,241)180   drawnexticon(32,192,246)185   drawnexticon(48,192,7)190   drawnexticon(48,224,7)195   drawnexticon(32,208,243)200   setuptile():sizemap(tx,ty)205   tilepos(1,0,0,0)210   posx=100:posy=100220   uitext():gosub 8000:rem "load Ml routines"250   rem "Main loop"260   repeat 270   getinput()360   if posx>320 then posx=320370   if posx<4 then posx=4380   if posy<4 then posy=4390   if posy>240 then posy=240400   sprite 0 to posx,posy410   if b1<>0:rem "mouse button pressed"420   if posy>192+4:rem "menu & tiles area"430   if posx>80+4:rem "tiles area"440   tnum=(posx-84)\16+((posy-196)\16)*15450   sprite 1 to (tnum%15)*16+88,(tnum\15)*16+200460   tnum=tnum+tp*45465   a$="Tile:"+right$("000"+str$(tnum),3):printat(65,47,a$)470   goto 2100480   endif 490   if posx>64+4:rem "Select layer"495   sprite 1:showtiles(0,tp):a$=spc(40):printat(21,50,a$)496   if posy>208 then cls :uitext()500   if posy>224+4 then lay=1:sprite 2 to 69,224+11:goto 530510   if posy>208+4 then lay=2:sprite 2 to 69,208+11:poke $D20C,1:goto 530520   if posy>192+4 then rem "lay=3:sprite 2 to 69,192+11:"530   repeat :getinput():until b1=0535   goto 2100540   endif 550   if posx>48+4:rem "Special Layer options"560   if posy>224+4:rem "Select property to set"570   prop=(prop+1)&7:a$=str$(prop):printat(14,57,a$)575   if lay=3 then cls :shadescreen(px,py,prop):uitext()580   repeat :getinput():until b1=0590   goto 2100600   endif 610   if posy>208+4:rem "Select Special Layer"615   hidetiles():a$="Property "+str$(prop)+" "+p$(prop):printat(21,50,a$)620   lay=3:sprite 2 to 53,208+11625   shadescreen(px,py,prop):uitext()630   a$="Layer Sp.":printat(70,47,a$)640   goto 2100650   endif 660   if posy>192+4:rem "Define Special Layer Properties"670   poke $D000,7:rem "turn off graphics"680   repeat 690   cls :print "Special Layer Properties"700   for c=0 to 7:print c;". ";p$(c):next 710   input "Type property number to define (0-7), or 8 to exit:";c720   if c<8730   input "Type Property name (10 chars):",a$740   p$(c)=left$(a$+spc(8),10)750   endif 760   until c=8770   cls :poke $D000,63780   uitext()785   goto 2100790   endif 800   endif 810   if posx>32+4820   if posy>208+4 rem "import sprites as tiles"821   importtiles():goto 2100825   endif 830   if posy>192+4840   cls :poke $D000,7:poke $D200,0:poke $D20C,0:poke $D218,0850   print "Thx you for using the Foenix 256jr Map Editor."852   memcopy $28000,$8000 poke 0855   a$="toolkit.bas":print "loading ";a$:bload a$,$28000:xgo 860   end 870   endif 880   endif 890   if posx>16+4900   if posy>224+4:rem "Change tile page"910   if tl<>0920   tp=tp+1:if tp=6 then tp=0930   showtiles(0,tp)935   a$=str$(tp):printat(7,57,a$)940   else 950   zap :printat(7,57,"0")960   endif 962   repeat :getinput():until b1=0965   goto 2100970   endif 980   if posy>208+4:rem "Open TileSet"990   cls :poke $D000,71000  input "Tileset to load (.tile will be added):";a$1010  loadtiles(0,a$)1020  cls :poke $D000,631030  uitext()1040  showtiles(0,0):tp=0:tl=11045  goto 21001050  endif 1060  endif 1070  if posx>41080  if posy>224+4:rem "Save Tile Map"1090  cls :poke $D000,71100  input "Map layers to save (1-3), 0 to cancel:";a1110  if a<>01120  input "Name of tilemap to use (.map will be appended):";a$1125  a$="maps/"+a$1130  for c=1 to a1135  addr=$40000+(c*$10000)1136  if c=11137  addr=addr-2:xpoke(addr,tx):xpoke(addr+1,ty)1138  endif 1140  m$=a$+str$(c)+".map":bsave m$,addr,6+(tx*ty)*21150  print "Saving ";m$;"...";addr;" ";6+(tx+ty)*2;" bytes"1160  next 1170  endif 1171  if a=31172  for c=0 to 71173  for d=0 to 101174  poke $7900+c*10+d,asc(mid$(p$(c),d+1,1))1175  next 1176  next 1178  m$=a$+".pmap":bsave m$,$7900,801179  endif 1180  print "Press any key to continue"1190  k$=inkey$():if k$=""then goto 11901200  cls :poke $D000,63:uitext()1205  goto 21001210  endif 1220  if posy>208+4:rem "Load Tile Map"1230  cls :poke $D000,71240  input "File name of tilemap to open (.map will be added):";a$1245  a$="maps/"+a$1250  m$=a$+"1.map":print m$;"...":try bload m$,$4FFFE to ec1260  if ec<>0 then print "File ";m$;" not found!":goto 13001270  m$=a$+"2.map":print m$;"...":try bload m$,$60000 to ec1280  if ec<>0 then print "File ";m$;" not found!":goto 13001290  m$=a$+"3.map":print m$;"...":try bload m$,$70000 to ec1291  try bload a$+".pmap",$7900 to ec1292  if ec=0 then readprops()1295  xpeek($4FFFE):tx=peekvalue1296  xpeek($4FFFF):ty=peekvalue:sizemap(tx,ty)1300  print "Press any key to continue"1305  k$=inkey$():if k$=""then goto 13051307  cls :poke $D000,63:uitext()1308  goto 21001310  endif 1320  if posy>192+41330  cls :poke $D000,71340  input "Set tile Map size X (0-255):";tx1350  input "Set tile Map size Y (0-255):";ty1355  sizemap(tx,ty)1360  cls :poke $D000,63:uitext()1365  goto 21001370  endif 1380  endif 1390  else 1400  rem "Paint tile in TileMap"1410  addr=px*2+((posx-8)\16)*2+(py+((posy-8)\16))*tx*2+(lay)*$10000+$400001415  if lay<>31420  xpoke(addr,tnum):xpoke(addr+3,8)1425  else :rem "Paint a special layer tile"1426  xpeek(addr):val=peekvalue1427  pow2(prop):tstval=pow1429  if (val&tstval)<>01430  val=val-tstval:unshadetile(((posx-8)\16),(posy-8)\16,colsh)1431  else 1432  val=val+tstval:shadetile(((posx-8)\16),(posy-8)\16,colsh)1433  endif 1434  xpoke(addr,val)1435  repeat :getinput():until b1=01438  endif 1439  endif 1440  endif 1445  rem "Read keyboard commands"1450  k=inkey()1460  if k=14:rem "scroll map down"1470  if py+13<=ty1480  for c=0 to 15:tilepos(px,py,0,c):next 1490  py=py+1:tilepos(px,py,0,0)1495  if lay=3 then cls :shadescreen(px,py,prop)1500  endif 1510  uitext()1520  endif 1530  if k=16:rem "scroll map up"1540  if py>01550  for c=15 downto 0:tilepos(px,py-1,0,c):next 1560  py=py-1:tilepos(px,py,0,0)1570  endif 1575  if lay=3 then cls :shadescreen(px,py,prop)1580  uitext()1590  endif 1600  if k=6:rem "scroll map right"1610  if px+19<tx1620  for c=0 to 15:tilepos(px,py,c,0):next 1630  px=px+1:tilepos(px,py,0,0)1640  endif 1645  if lay=3 then cls :shadescreen(px,py,prop)1650  uitext()1660  endif 1670  if k=2:rem "scroll map left"1680  if px>11690  for c=15 downto 0:tilepos(px-1,py,c,0):next 1700  px=px-1:tilepos(px,py,0,0)1710  endif 1715  if lay=3 then cls :shadescreen(px,py,prop)1720  uitext()1730  endif 1740  if k=129 then colsh=(colsh+1)&15:shadescreen(px,py,prop)1750  if k=119:rem "map page up"1760  if py>01780  py=py-12:if py<0 then py=01785  tilepos(px,py,0,0)1790  endif 1805  if lay=3 then cls :shadescreen(px,py,prop)1810  uitext()1820  endif 1830  if k=100:rem "map page right"1840  if px+19<tx1860  px=px+20:if px>tx-19 then px=tx-191865  tilepos(px,py,0,0)1870  endif 1880  if lay=3 then cls :shadescreen(px,py,prop)1890  uitext()1900  endif 1910  if k=97:rem "map page left"1920  if px>11940  px=px-20:if px<0 then px=11945  tilepos(px,py,0,0)1950  endif 1965  if lay=3 then cls :shadescreen(px,py,prop)1970  uitext()1980  endif 2000  if k=115:rem "map page down"2010  if py+12<=ty2030  py=py+12:if py>ty-12 then py=ty-122035  tilepos(px,py,0,0)2040  if lay=3 then cls :shadescreen(px,py,prop)2050  endif 2060  uitext()2070  endif 2100  until 1<>15000  proc defspr()5005  memcopy $30000,$200 poke 05010  xpoke($30000,$11):xpoke($30001,1):xpoke($30002,0):rem "16x16 spr"5020  for c=0 to 155030  xpoke($30003+c*16,255):xpoke($30012+c*16,255)5040  next 5050  memcopy $30003,$F poke 255:memcopy $300F3,$F poke 2555060  xpoke($30103,1):xpoke($30104,0):rem "16x16 spr"5070  for c=0 to 255:read a:xpoke($30105+c,a):next 5075  xpoke($30205,0):xpoke($30206,0):rem "8x8 spr"5080  for c=0 to 63:read a:xpoke($30207+c,a):next 5090  endproc 5100  proc xpoke(addr,value)5110  poke peekloc,value5120  memcopy peekloc,1 to addr5130  endproc 5150  proc drawnexticon(x,y,col)5160  local c:local d:local e:local addr5170  for c=0 to 155180  for d=0 to 15190  read a5200  for e=0 to 75210  if a&128 then plot color col to d*8+e+x,c+y5220  a=a<<15230  next 5240  next 5250  next 5260  endproc 5300  proc loadpalette(name$,n)5310  name$="palettes/"+name$+".pal"5320  try bload name$,$7900 to ec5325  print "Loading ";name$5330  if ec<>05335  if retry<>15336  retry=15340  print "File "+name$+" Not Found!"5345  print "Using default palette.."5347  loadpalette("default",1)5348  endif 5350  endif 5360  ?1=1:for c=0 to 1023:?($D000+c+n*$400)=?($7900+c):next :?1=05365  retry=05370  endproc 5400  proc loadtiles(n,name$)5405  memcopy $40000,$10000 poke 05410  a$="tiles/"+name$+".tile"5415  cls :print "Loading ";a$5420  try bload a$,$40100 to ec5430  if ec<>05450  cls :print "Tile file "+name$+" not found, try again"5550  goto 55705560  endif 5565  loadpalette(name$,1)5570  endproc 5600  proc showtiles(n,p):rem "n - tileset, p-page (0-5)"5605  addr=$40000+(p*45*256):spa=$D9185610  for c=0 to 2:rem "3 rows"5620  for d=0 to 14:rem "15 tiles each"5630  sn=3+c*15+d:sprite sn to 84+d*16,196+c*165640  pokel spa+1,addr:addr=addr+2565650  poke spa,67:spa=spa+8:rem "1-on,2-lut 1,64-size 16"5660  next 5670  next 5680  endproc 5700  proc processjoy()5710  x=joyx(0):y=joyy(0):b1=joyb(0)5720  endproc 5730  if m#>2 then m#=25750  proc printat(x,y,a$)5760  local pos:pos=x+y*80:?1=2:rem "set i/o to text memory"5770  for c=0 to len(a$)-1:?(pos+c+$C000)=asc(mid$(a$,c+1,1)):next 5780  ?1=05790  endproc 5800  proc getmouse()5810  dx=0:dy=0:dz=0:mb1=0:mb2=0:mb3=05820  mouse c,c,c,mb1,mb2,mb35830  mdelta dx,dy,dz,c,c,c5840  dx=int(dx*mousespeed#):dy=int(dy*mousespeed#)5850  endproc 5900  proc statusmsg(m$)5910  printat(0,0,spc(79)):printat(0,0,m$)5920  endproc 5950  proc uitext()5955  printat(0,47,"Map Tile")5960  printat(12,47,"Layers")5965  a$=str$(tp):printat(7,57,a$)5970  a$=str$(prop):printat(14,57,a$)5975  a$="Map Size "+right$("000"+str$(tx),3)+"x"+right$("000"+str$(ty),3)5980  printat(20,47,a$)5985  a$="View ("+right$("000"+str$(px),3)+","+right$("000"+str$(py),3)5990  a$=a$+"-"+right$("000"+str$(px+20),3)+","+right$("000"+str$(py+12),3)+")"5995  printat(38,47,a$)6000  if lay=36005  hidetiles():a$="Property "+str$(prop)+" "+p$(prop):printat(21,50,a$)6007  endif 6010  endproc 6050  proc setuptile()6060  poke $D002,80:poke $D003,4:rem "turn on 2 tile layers"6070  memcopy $40000,$FFF0 poke 0:for c=1 to 200:next 6071  memcopy $50000,$FFF0 poke 0:for c=1 to 200:next 6072  memcopy $60000,$FFF0 poke 0:for c=1 to 200:next 6073  memcopy $70000,$FFF0 poke 0:for c=1 to 200:next 6074  poke $D200,1:for c=1 to 100:next 6075  poke $D20C,1:for c=1 to 100:next 6076  pokel $D101,$10000:poke $D100,1:for c=1 to 100:next 6080  pokel $D201,$50000:pokel $D20C+1,$600006090  pokel $D280,$40000:rem "set Tile graphics address"6100  tilepos(0,0,0,0)6110  endproc 6150  proc tilepos(tpx,tpy,sx,sy)6160  rem "Positions upper map corner at tpx, tpy, fine scroll sx,sy"6170  local txl,txh,tyl,tyh6180  txl=(tpx&$0F)*16:txh=(tpx&$F0)\166190  tyl=(tpy&$0F)*16:tyh=(tpy&$F0)\166200  poke $D208,txl+sx:poke $D209,txh6210  poke $D20C+8,txl+sx:poke $D20C+9,txh6220  poke $D20A,tyl+sy:poke $D20B,tyh6230  poke $D20C+$A,tyl+sy:poke $D20C+$B,tyh6240  endproc 6300  proc tilesoff()6305  cls 6310  ?1=0:poke $D218,0:for c=1 to 10:next 6320  poke $D20C,0:for c=1 to 10:next 6330  poke $D200,06340  bitmap off 6350  endproc 6400  proc sizemap(x,y)6410  poke $D204,x:poke $D20C+4,x6420  poke $D206,y:poke $D218+6,y6430  endproc 6500  proc shadetile(x,y,colsh)6510  rem "Shade tile at x,y position"6520  rem "Expect values in x (0,19) y(0,12)"6530  local shx,shy:shx=x*4:shy=y*46540  for c=0 to 36550  for d=0 to 36560  ?1=2:?($C000+(shx+c)+(shy+d)*80)=31:?1=0:rem "166"6565  ?1=3:?($C000+(shx+c)+(shy+d)*80)=colsh*16:?1=06570  next 6580  next 6590  endproc 6600  proc unshadetile(x,y,colsh)6610  rem "Shade tile at x,y position"6620  rem "Expect values in x (0,19) y(0,12)"6630  local shx,shy:shx=x*4:shy=y*46640  for c=0 to 36650  for d=0 to 36660  ?1=2:?($C000+(shx+c)+(shy+d)*80)=32:?1=06665  ?1=3:?($C000+(shx+c)+(shy+d)*80)=colsh*16:?1=06670  next 6680  next 6690  endproc 6700  proc getinput()6710  getmouse()6720  if dx+dy+dz+mb1+mb2+mb3<>06730  posx=posx+dx:posy=posy+dy:b1=mb1:b2=mb2:mflg=true 6740  else 6750  if event(move1,1)6760  processjoy()6770  posx=posx+2*x:posy=posy+2*y6780  endif 6790  endif 6800  endproc 6850  proc shadescreen(spx,spy,sprop)6852  local sc:local sd:local ststval:local saddr:local sval6855  pow2(sprop):ststval=pow6865  for sd=0 to 116870  saddr=$70000+(spx*2)+(spy+sd)*tx*26875  memcopy saddr,40 to rows6876  for sc=0 to 196880  sval=peek(rows+sc*2)6890  if (sval&ststval)>06895  poke scol,colsh*16:poke sxpos,sc:poke sypos,sd:call shade6897  endif 6900  next 6910  next 6920  endproc 6950  proc pow2(power)6960  pow=16970  while power>06980  pow=pow<<1:power=power-16990  wend 7000  endproc 7050  proc hidetiles()7060  for c=0 to 2:rem "3 rows"7070  for d=0 to 14:rem "15 tiles each"7080  sn=3+d+c*15:sprite sn off 7090  next 7100  next 7110  endproc 7150  proc xpeek(addr)7160  local block:block=addr\8192:local prevblock:rem "calcualte block"7170  local offset:offset=addr-(block*8192):rem "calculate offset"7180  ?0=179:rem "Enable edit on MLUT 0"7190  prevblock=?$0E:rem "save block under I/O"7200  ?$E=block:rem "map temp block under I/O memory"7210  ?1=4:peekvalue=?($C000+offset):?1=07220  ?$E=prevblock:rem "restore block under I/o"7230  endproc 7250  proc readprops()7260  for c=0 to 7:p$(c)="":next 7270  for c=0 to 77280  for d=0 to 97290  a$=chr$(peek($7900+c*10+d))7300  p$(c)=p$(c)+a$7310  next 7320  next 7330  endproc 7340  proc importtiles()7345  memcopy $40000,$10000 poke 07350  cls :poke $D000,77360  input "Name of sprite file to import (.spr will be appended):";a$7370  addr=$40000-1793:rem "remove sprite index and sprite count"7375  name$=a$+".spr"7380  try bload name$,addr to ec7390  if ec<>07400  print "file not found!"7410  else 7420  print "File Imported!"7425  loadpalette(a$,1)7430  endif 7440  print "press any key to continue"7450  k$=inkey$():if k$=""then goto 74507460  cls :poke $D000,63:uitext()7470  showtiles(0,0):tp=0:tl=17480  endproc 8000  rem "mlroutine for shadingscreen"8010  shade=$7800:sxpos=alloc(1):sypos=alloc(1):scol=alloc(1)8020  for c=0 to 18030  assemble shade,c8040  rem "Assembler code"8050  jsr conf8060  lda #$028070  sta $00018080  ldy #$008090  .outloop lda #$1F8100  lda #$1F8110  ldx #$008120  .inloop sta $C000,x8130  inx 8140  cpx #$048150  bne inloop8160  clc 8170  lda #808190  adc inloop+18200  sta inloop+18210  lda #008220  adc inloop+28230  sta inloop+28240  iny 8250  cpy #$048260  bne outloop8270  lda #$00:rem "Return to I/O page 0"8280  sta $00018290  .endlabel rts 8300  rem "setup routine"8310  .conf lda #$008320  sta $0001:rem "ensure Im on I/O page 0"8330  sta inloop+1:rem "set initial text memory to $c000"8340  lda #$C08350  sta inloop+28360  lda #$008370  sta $DE01:rem "load mult A value 16bit"8380  lda sypos:rem "multiply num of rows x 320"8390  sta $DE008400  lda #$018410  sta $DE038420  lda #$408430  sta $DE028440  lda $DE10:rem "mult result in $DE10,$DE11"8450  clc 8460  adc inloop+18470  sta inloop+18480  lda $DE118490  adc inloop+28500  sta inloop+28510  lda sxpos:rem "multiply num of cols x 4"8520  sta $DE008530  lda #$008540  sta $DE038550  lda #$048560  sta $DE028570  lda $DE10:rem "mult result in $DE10,$DE11"8580  clc 8590  adc inloop+18600  sta inloop+18610  lda $DE118620  adc inloop+28630  sta inloop+28650  lda #$038660  sta $01:rem "set I/o to text color map"8670  ldx #$008680  lda scol8690  .cloop sta $C000,x8700  sta $C100,x8710  sta $C200,x8720  sta $C300,x8730  sta $C400,x8740  sta $C500,x8750  sta $C600,x8760  sta $C700,x8770  sta $C800,x8780  sta $C900,x8790  sta $CA00,x8800  sta $CB00,x8810  sta $CC00,x8820  sta $CD00,x8850  inx 8860  cpx #$008870  bne cloop8880  ldx #$008890  .cloop2 sta $CE00,x8900  inx 8910  cpx #$B08920  bne cloop28930  rts 8940  next 8950  return 9500  rem "Pointer Sprite 16x16"9510  data 0,1,1,0,0,0,0,0,1,1,1,0,0,0,0,0,1,7,7,1,0,0,1,1,7,7,7,1,0,0,0,09520  data 1,7,7,7,1,1,7,7,7,1,4,7,1,0,0,0,1,4,7,7,7,7,1,4,7,7,7,7,1,0,0,09530  data 0,1,4,7,7,7,7,7,7,7,1,7,7,1,0,0,0,0,1,4,7,7,7,7,1,7,7,1,7,1,0,09540  data 0,0,1,1,4,7,7,7,7,1,7,7,7,1,1,0,0,0,1,4,1,4,7,7,7,7,7,7,1,7,7,19550  data 0,0,1,4,4,4,7,7,7,7,7,7,7,7,7,1,0,0,0,1,4,4,4,7,7,7,7,7,7,4,1,09560  data 0,0,0,0,1,4,4,4,4,1,7,7,4,1,0,0,0,0,0,0,0,1,1,1,1,4,7,4,1,0,0,09570  data 0,0,0,0,0,0,0,1,4,4,4,1,0,0,0,0,0,0,0,0,0,0,0,1,4,4,1,0,0,0,0,09580  data 0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,09600  rem "Marker sprite 8x8"9610  data 000,000,000,000,000,000,000,0009620  data 000,000,000,000,000,000,000,0009630  data 000,000,000,000,000,000,000,0009640  data 240,000,000,000,000,000,000,0009650  data 248,240,000,000,000,000,000,0009660  data 248,240,240,000,000,000,000,0009670  data 248,240,240,240,000,000,000,0009680  data 248,248,248,248,248,000,000,0009998  rem "ICONS DATA"9999  rem "Map Conf"10000 data 0,0,127,224,64,48,64,40,70,36,67,60,83,4,95,410010 data 79,132,65,196,64,228,64,100,64,4,127,252,0,0,0,010015 rem "Open tile set"10020 data 0,0,0,0,0,0,62,0,35,248,32,8,39,254,36,15810030 data 36,156,47,252,44,152,44,152,63,240,0,0,0,0,0,010035 rem "Open tile map"10040 data 0,0,0,0,0,0,124,0,71,240,64,16,79,252,79,25210050 data 95,248,95,248,127,240,127,240,127,224,0,0,0,0,0,010055 rem "Save Tile map"10060 data 0,0,127,240,96,48,107,176,96,48,63,224,125,240,120,24010070 data 125,240,127,240,127,240,125,240,125,240,0,0,0,0,0,010075 rem "Next Tileset"10080 data 0,0,0,0,0,238,0,224,48,224,24,0,12,224,6,22410090 data 12,238,24,0,48,238,0,238,0,238,0,0,0,0,0,010095 rem "Special Layer"10100 data 3,192,6,32,6,0,3,192,0,96,4,96,3,192,0,010110 data 1,192,7,240,31,252,127,255,31,252,7,240,1,192,0,010115 rem "TileMap 1"10120 data 1,128,3,128,1,128,1,128,1,128,1,128,3,192,0,010130 data 1,192,7,240,31,252,127,255,31,252,7,240,1,192,0,010135 rem "TileMap 2"10140 data 1,192,2,96,0,96,0,192,1,128,3,0,3,224,0,010150 data 1,192,7,240,31,252,127,255,31,252,7,240,1,192,0,010155 rem "TileMap 3"10160 rem "data 1,192,2,96,0,96,0,192,0,96,2,96,1,192,0,0"10165 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,010170 rem "data 1,192,7,240,31,252,127,255,31,252,7,240,1,192,0,0"10173 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,010175 rem "Exit"10180 data 0,0,0,0,0,0,255,252,138,162,189,183,154,183,138,18210190 data 255,253,0,3,255,254,255,252,0,0,0,0,0,0,0,010195 rem "Special layer Conf"10200 data 0,0,0,0,0,0,0,6,0,9,0,17,0,34,1,19610210 data 6,8,28,28,125,159,31,156,7,48,1,192,0,0,0,010215 rem "Property #"10220 data 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,010230 data 0,0,119,119,85,85,119,87,70,84,69,116,0,0,0,010240 rem "Import from sprite"10250 data 0,0,0,0,0,0,62,0,35,248,32,8,39,254,38,3010260 data 37,44,44,12,46,216,45,232,63,240,0,0,0,0,0,0