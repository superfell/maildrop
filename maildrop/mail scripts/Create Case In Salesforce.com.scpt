FasdUAS 1.101.10   ��   ��    k             l      ��  ��    f ` script to take the selected message in mail.app and create an email task in salesforce from it      � 	 	 �   s c r i p t   t o   t a k e   t h e   s e l e c t e d   m e s s a g e   i n   m a i l . a p p   a n d   c r e a t e   a n   e m a i l   t a s k   i n   s a l e s f o r c e   f r o m   i t     
  
 l     ��������  ��  ��        l     ����  O        r        I   ���� 
�� .corecrel****      � null��    �� ��
�� 
kocl  m    ��
�� 
maIL��    o      ���� 0 theemail theEmail  m       *                                                                                      @ alis    �  Macintosh HD               ��wH+   hYMaildrop.app                                                   �����        ����  	                Debug     ���      �	U      hY �_� �\W �kT �k% ��� ��  n�  TMacintosh HD:Users:simon:googleCode:maildrop:trunk:maildrop:build:Debug:Maildrop.app    M a i l d r o p . a p p    M a c i n t o s h   H D  GUsers/simon/googleCode/maildrop/trunk/maildrop/build/Debug/Maildrop.app   /    ��  ��  ��        l   & ����  Z    &  ����  I    �� ���� 0 mybuildemail myBuildEmail   ��  o    ���� 0 theemail theEmail��  ��    O   "    I   !�� ��
�� .creaCASEnull���     maIL  o    ���� 0 theemail theEmail��    m        *                                                                                      @ alis    �  Macintosh HD               ��wH+   hYMaildrop.app                                                   �����        ����  	                Debug     ���      �	U      hY �_� �\W �kT �k% ��� ��  n�  TMacintosh HD:Users:simon:googleCode:maildrop:trunk:maildrop:build:Debug:Maildrop.app    M a i l d r o p . a p p    M a c i n t o s h   H D  GUsers/simon/googleCode/maildrop/trunk/maildrop/build/Debug/Maildrop.app   /    ��  ��  ��  ��  ��     ! " ! l  ' 1 #���� # O  ' 1 $ % $ I  + 0�� &��
�� .coredelonull���     obj  & o   + ,���� 0 theemail theEmail��   % m   ' ( ' '*                                                                                      @ alis    �  Macintosh HD               ��wH+   hYMaildrop.app                                                   �����        ����  	                Debug     ���      �	U      hY �_� �\W �kT �k% ��� ��  n�  TMacintosh HD:Users:simon:googleCode:maildrop:trunk:maildrop:build:Debug:Maildrop.app    M a i l d r o p . a p p    M a c i n t o s h   H D  GUsers/simon/googleCode/maildrop/trunk/maildrop/build/Debug/Maildrop.app   /    ��  ��  ��   "  ( ) ( l     ��������  ��  ��   )  * + * l     ��������  ��  ��   +  , - , i      . / . I      �� 0���� 0 mybuildemail myBuildEmail 0  1�� 1 o      ���� 0 theemail theEmail��  ��   / O    � 2 3 2 k   � 4 4  5 6 5 r     7 8 7 l    9���� 9 I   �� :��
�� .corecnte****       **** : n    
 ; < ; 1    
��
�� 
smgs < l    =���� = 4   �� >
�� 
mvwr > m    ���� ��  ��  ��  ��  ��   8 o      ���� 0 selcount selCount 6  ? @ ? Z   � A B C D A =    E F E o    ���� 0 selcount selCount F m    ����   B I   �� G H
�� .sysodlogaskr        TEXT G m     I I � J J L P l e a s e   s e l e c t   a   m e s s a g e   i n   M a i l   f i r s t . H �� K��
�� 
disp K m    ���� ��   C  L M L =  ! $ N O N o   ! "���� 0 selcount selCount O m   " #����  M  P�� P k   ' Q Q  R S R r   ' / T U T n   ' - V W V 1   + -��
�� 
smgs W 4  ' +�� X
�� 
mvwr X m   ) *����  U o      ���� *0 theselectedmessages theSelectedMessages S  Y Z Y r   0 6 [ \ [ n   0 4 ] ^ ] 4   1 4�� _
�� 
cobj _ m   2 3����  ^ o   0 1���� *0 theselectedmessages theSelectedMessages \ o      ���� 0 eachmessage eachMessage Z  ` a ` r   7 < b c b n   7 : d e d 1   8 :��
�� 
subj e o   7 8���� 0 eachmessage eachMessage c o      ���� 0 
thesubject 
theSubject a  f g f r   = B h i h n   = @ j k j 1   > @��
�� 
ctnt k o   = >���� 0 eachmessage eachMessage i o      ���� 0 thebody theBody g  l m l r   C H n o n n   C F p q p 1   D F��
�� 
rdrc q o   C D���� 0 eachmessage eachMessage o o      ���� 0 thedate theDate m  r s r r   I N t u t n   I L v w v m   J L��
�� 
mbxp w o   I J���� 0 eachmessage eachMessage u o      ���� 0 
themailbox 
theMailbox s  x y x r   O W z { z l  O U |���� | n   O U } ~ } 1   S U��
�� 
pnam ~ l  O S ����  n   O S � � � 4  P S�� �
�� 
trcp � m   Q R����  � o   O P���� 0 eachmessage eachMessage��  ��  ��  ��   { o      ���� 0 toname toName y  � � � r   X ` � � � l  X ^ ����� � n   X ^ � � � 1   \ ^��
�� 
radd � l  X \ ����� � n   X \ � � � 4  Y \�� �
�� 
trcp � m   Z [����  � o   X Y���� 0 eachmessage eachMessage��  ��  ��  ��   � o      ���� 0 toaddr toAddr �  � � � r   a f � � � n   a d � � � 1   b d��
�� 
sndr � o   a b���� 0 eachmessage eachMessage � o      ���� 0 	thesender 	theSender �  � � � r   g n � � � I  g l�� ���
�� .emaleafnutf8        utf8 � o   g h���� 0 	thesender 	theSender��   � o      ���� 0 thefromname theFromName �  � � � r   o v � � � I  o t�� ���
�� .emaleauautf8        utf8 � o   o p���� 0 	thesender 	theSender��   � o      ���� 0 thefromaddr theFromAddr �  � � � r   w � � � � n  w � � � � I   x ��� ����� 0 isinmboxtree IsInMboxTree �  � � � n   x { � � � m   y {��
�� 
mbxp � o   x y���� 0 eachmessage eachMessage �  ��� � 1   { ���
�� 
stmb��  ��   �  f   w x � o      ���� 0 
isoutgoing 
isOutgoing �  � � � Q   � � � � � � r   � � � � � o   � ����� 0 thefromname theFromName � o      ���� 0 temp   � R      ������
�� .ascrerr ****      � ****��  ��   � r   � � � � � m   � � � � � � �   � o      ���� 0 thefromname theFromName �  � � � Q   � � � � � � r   � � � � � o   � ����� 0 toname toName � o      ���� 0 temp   � R      ������
�� .ascrerr ****      � ****��  ��   � r   � � � � � m   � � � � � � �   � o      ���� 0 toname toName �  � � � r   � � � � � n   � � � � � 2   � ���
�� 
attc � o   � ����� 0 eachmessage eachMessage � o      �� 0 atts   �  � � � X   �5 ��~ � � k   �0 � �  � � � r   � � � � � n   � � � � � 1   � ��}
�} 
attp � o   � ��|�| 0 att   � o      �{�{ 0 mt   �  � � � r   � � � � � n   � � � � � 1   � ��z
�z 
pnam � o   � ��y�y 0 att   � o      �x�x 0 nm   �  � � � O   �" � � � k   �! � �  � � � r   � � � � � I  � ��w�v �
�w .corecrel****      � null�v   � �u � �
�u 
kocl � m   � ��t
�t 
atTT � �s ��r
�s 
insh � n   � � � � �  ;   � � � n   � � � � � 2   � ��q
�q 
atTT � o   � ��p�p 0 theemail theEmail�r   � o      �o�o 0 theatt theAtt �  � � � r    � � � o   �n�n 0 mt   � n       � � � 1  
�m
�m 
miME � o  �l�l 0 theatt theAtt �  � � � r   � � � o  �k�k 0 nm   � n       � � � 1  �j
�j 
pnam � o  �i�i 0 theatt theAtt �  ��h � r  ! � � � n   � � � m  �g
�g 
file � o  �f�f 0 theatt theAtt � o      �e�e 0 filepath filePath�h   � m   � � � �*                                                                                      @ alis    �  Macintosh HD               ��wH+   hYMaildrop.app                                                   �����        ����  	                Debug     ���      �	U      hY �_� �\W �kT �k% ��� ��  n�  TMacintosh HD:Users:simon:googleCode:maildrop:trunk:maildrop:build:Debug:Maildrop.app    M a i l d r o p . a p p    M a c i n t o s h   H D  GUsers/simon/googleCode/maildrop/trunk/maildrop/build/Debug/Maildrop.app   /    ��   �  ��d � I #0�c � �
�c .coresavenull���     obj  � o  #&�b�b 0 att   � �a ��`
�a 
kfil � o  ),�_�_ 0 filepath filePath�`  �d  �~ 0 att   � o   � ��^�^ 0 atts   �  � � � l 66�]�\�[�]  �\  �[   �    O  6| k  <{  r  <C o  <=�Z�Z 0 thebody theBody n      	
	 1  >B�Y
�Y 
pBDY
 o  =>�X�X 0 theemail theEmail  r  DK o  DE�W�W 0 thefromname theFromName n       1  FJ�V
�V 
frNM o  EF�U�U 0 theemail theEmail  r  LS o  LM�T�T 0 thefromaddr theFromAddr n       1  NR�S
�S 
frAD o  MN�R�R 0 theemail theEmail  r  T[ o  TU�Q�Q 0 toname toName n       1  VZ�P
�P 
toNM o  UV�O�O 0 theemail theEmail  r  \c  o  \]�N�N 0 toaddr toAddr  n      !"! 1  ^b�M
�M 
toAD" o  ]^�L�L 0 theemail theEmail #$# r  dk%&% o  de�K�K 0 
isoutgoing 
isOutgoing& n      '(' 1  fj�J
�J 
seNT( o  ef�I�I 0 theemail theEmail$ )*) r  ls+,+ o  lm�H�H 0 
thesubject 
theSubject, n      -.- 1  nr�G
�G 
suBJ. o  mn�F�F 0 theemail theEmail* /�E/ r  t{010 o  tu�D�D 0 thedate theDate1 n      232 1  vz�C
�C 
DATE3 o  uv�B�B 0 theemail theEmail�E   m  6944*                                                                                      @ alis    �  Macintosh HD               ��wH+   hYMaildrop.app                                                   �����        ����  	                Debug     ���      �	U      hY �_� �\W �kT �k% ��� ��  n�  TMacintosh HD:Users:simon:googleCode:maildrop:trunk:maildrop:build:Debug:Maildrop.app    M a i l d r o p . a p p    M a c i n t o s h   H D  GUsers/simon/googleCode/maildrop/trunk/maildrop/build/Debug/Maildrop.app   /    ��   5�A5 L  }66 m  }~�@
�@ boovtrue�A  ��   D I ���?78
�? .sysodlogaskr        TEXT7 m  ��99 �:: Z P l e a s e   s e l e c t   o n l y   o n e   m e s s a g e   i n   M a i l   f i r s t .8 �>;�=
�> 
disp; m  ���<�< �=   @ <�;< L  ��== m  ���:
�: boovfals�;   3 m     >>�                                                                                  emal  alis    D  Macintosh HD               ��wH+  �BMail.app                                                       ��PƎ��        ����  	                Applications    ���      Ǝ�    �B  "Macintosh HD:Applications:Mail.app    M a i l . a p p    M a c i n t o s h   H D  Applications/Mail.app   / ��   - ?@? l     �9�8�7�9  �8  �7  @ ABA l      �6CD�6  C P J This looks in the tree of mailboxes rooted at mboxToCheck for mboxToFind    D �EE �   T h i s   l o o k s   i n   t h e   t r e e   o f   m a i l b o x e s   r o o t e d   a t   m b o x T o C h e c k   f o r   m b o x T o F i n d  B FGF i    HIH I      �5J�4�5 0 isinmboxtree IsInMboxTreeJ KLK o      �3�3 0 
mboxtofind 
mboxToFindL M�2M o      �1�1 0 mboxtocheck mboxTocheck�2  �4  I k     BNN OPO O     ?QRQ k    >SS TUT r    	VWV n    XYX 2    �0
�0 
mbxpY o    �/�/ 0 mboxtocheck mboxTocheckW o      �.�. 0 cmb  U Z�-Z X   
 >[�,\[ k    9]] ^_^ Z    (`a�+�*` =    bcb n    ded 1    �)
�) 
pcnte o    �(�( 0 m  c o    �'�' 0 
mboxtofind 
mboxToFinda L   " $ff m   " #�&
�& boovtrue�+  �*  _ g�%g Z   ) 9hi�$�#h n  ) 0jkj I   * 0�"l�!�" 0 isinmboxtree IsInMboxTreel mnm o   * +� �  0 
mboxtofind 
mboxToFindn o�o o   + ,�� 0 m  �  �!  k  f   ) *i L   3 5pp m   3 4�
� boovtrue�$  �#  �%  �, 0 m  \ o    �� 0 cmb  �-  R m     qq�                                                                                  emal  alis    D  Macintosh HD               ��wH+  �BMail.app                                                       ��PƎ��        ����  	                Applications    ���      Ǝ�    �B  "Macintosh HD:Applications:Mail.app    M a i l . a p p    M a c i n t o s h   H D  Applications/Mail.app   / ��  P r�r L   @ Bss m   @ A�
� boovfals�  G t�t l     ����  �  �  �       �uvwx�  u ���� 0 mybuildemail myBuildEmail� 0 isinmboxtree IsInMboxTree
� .aevtoappnull  �   � ****v � /��yz�� 0 mybuildemail myBuildEmail� �{� {  �� 0 theemail theEmail�  y ��
�	��������� ������������������� 0 theemail theEmail�
 0 selcount selCount�	 *0 theselectedmessages theSelectedMessages� 0 eachmessage eachMessage� 0 
thesubject 
theSubject� 0 thebody theBody� 0 thedate theDate� 0 
themailbox 
theMailbox� 0 toname toName� 0 toaddr toAddr� 0 	thesender 	theSender�  0 thefromname theFromName�� 0 thefromaddr theFromAddr�� 0 
isoutgoing 
isOutgoing�� 0 temp  �� 0 atts  �� 0 att  �� 0 mt  �� 0 nm  �� 0 theatt theAtt�� 0 filepath filePathz ->������ I���������������������������������� � ������� ���������������������������������9
�� 
mvwr
�� 
smgs
�� .corecnte****       ****
�� 
disp
�� .sysodlogaskr        TEXT
�� 
cobj
�� 
subj
�� 
ctnt
�� 
rdrc
�� 
mbxp
�� 
trcp
�� 
pnam
�� 
radd
�� 
sndr
�� .emaleafnutf8        utf8
�� .emaleauautf8        utf8
�� 
stmb�� 0 isinmboxtree IsInMboxTree��  ��  
�� 
attc
�� 
kocl
�� 
attp
�� 
atTT
�� 
insh�� 
�� .corecrel****      � null
�� 
miME
�� 
file
�� 
kfil
�� .coresavenull���     obj 
�� 
pBDY
�� 
frNM
�� 
frAD
�� 
toNM
�� 
toAD
�� 
seNT
�� 
suBJ
�� 
DATE����*�k/�,j E�O�j  ��kl Yl�k ]*�k/�,E�O��k/E�O��,E�O��,E�O��,E�O��,E�O��k/�,E�O��k/�,E�O��,E�O�j E�O�j E�O)��,*a ,l+ E�O �E�W X  a E�O �E�W X  a E�O�a -E�O }�[a �l kh ] a ,E^ O] �,E^ Oa  >*a a a �a -6a  E^ O] ] a  ,FO] ] �,FO] a !,E^ UO] a "] l #[OY��Oa  A��a $,FO��a %,FO��a &,FO��a ',FO��a (,FO��a ),FO��a *,FO��a +,FUOeY a ,�kl OfUw ��I����|}���� 0 isinmboxtree IsInMboxTree�� ��~�� ~  ������ 0 
mboxtofind 
mboxToFind�� 0 mboxtocheck mboxTocheck��  | ���������� 0 
mboxtofind 
mboxToFind�� 0 mboxtocheck mboxTocheck�� 0 cmb  �� 0 m  } q������������
�� 
mbxp
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
pcnt�� 0 isinmboxtree IsInMboxTree�� C� <��-E�O 3�[��l kh ��,�  eY hO)��l+  eY h[OY��UOfx ����������
�� .aevtoappnull  �   � **** k     1��  ��  ��  !����  ��  ��  �  �  ��������������
�� 
kocl
�� 
maIL
�� .corecrel****      � null�� 0 theemail theEmail�� 0 mybuildemail myBuildEmail
�� .creaCASEnull���     maIL
�� .coredelonull���     obj �� 2� *��l E�UO*�k+  � �j UY hO� �j Uascr  ��ޭ