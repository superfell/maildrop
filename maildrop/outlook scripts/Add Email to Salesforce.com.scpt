FasdUAS 1.101.10   ��   ��    k             l   l ����  O    l  	  k   k 
 
     r    	    1    ��
�� 
CMgs  o      ���� $0 selectedmessages selectedMessages      Z   
   ����  =  
     o   
 ���� $0 selectedmessages selectedMessages  J    ����    k           I   ��  
�� .sysodlogaskr        TEXT  m       �   n P l e a s e   s e l e c t   a   m e s s a g e   f i r s t   a n d   t h e n   r u n   t h i s   s c r i p t .  �� ��
�� 
disp  m    ���� ��     ��  L    ����  ��  ��  ��     ��  X    k ��    k   0f ! !  " # " r   0 5 $ % $ n   0 3 & ' & 1   1 3��
�� 
subj ' o   0 1���� 0 
themessage 
theMessage % o      ���� 0 
thesubject 
theSubject #  ( ) ( Z  6 C * +���� * =  6 9 , - , o   6 7���� 0 
thesubject 
theSubject - m   7 8��
�� 
msng + r   < ? . / . m   < = 0 0 � 1 1   / o      ���� 0 
thesubject 
theSubject��  ��   )  2 3 2 r   D K 4 5 4 c   D I 6 7 6 n   D G 8 9 8 1   E G��
�� 
ctnt 9 o   D E���� 0 
themessage 
theMessage 7 m   G H��
�� 
TEXT 5 o      ���� 0 thebody theBody 3  : ; : Z   L( < =���� < n   L R > ? > 1   M Q��
�� 
pHtm ? o   L M���� 0 
themessage 
theMessage = k   U$ @ @  A B A r   U Z C D C o   U V���� 0 thebody theBody D o      ���� 0 	something   B  E F E l  [ [�� G H��   G   replace with newline    H � I I *   r e p l a c e   w i t h   n e w l i n e F  J K J l  [ [�� L M��   L G A these have to match exactly so trying to catch starting elements    M � N N �   t h e s e   h a v e   t o   m a t c h   e x a c t l y   s o   t r y i n g   t o   c a t c h   s t a r t i n g   e l e m e n t s K  O P O r   [ m Q R Q n   [ i S T S I   \ i�� U���� 0 replacetext replaceText U  V W V o   \ _��
�� 
ret  W  X Y X m   _ b Z Z � [ [   Y  \�� \ o   b e���� 0 	something  ��  ��   T  f   [ \ R o      ���� 0 	something   P  ] ^ ] r   n � _ ` _ n   n � a b a I   o ��� c���� 0 replacetext replaceText c  d e d m   o r f f � g g  < d i v e  h i h b   r y j k j o   r u��
�� 
ret  k m   u x l l � m m  < i  n�� n o   y |���� 0 	something  ��  ��   b  f   n o ` o      ���� 0 	something   ^  o p o r   � � q r q n   � � s t s I   � ��� u���� 0 replacetext replaceText u  v w v m   � � x x � y y  < b r w  z { z b   � � | } | o   � ���
�� 
ret  } m   � � ~ ~ �    < {  ��� � o   � ����� 0 	something  ��  ��   t  f   � � r o      ���� 0 	something   p  � � � r   � � � � � n   � � � � � I   � ��� ����� 0 replacetext replaceText �  � � � m   � � � � � � �  < p �  � � � b   � � � � � o   � ���
�� 
ret  � m   � � � � � � �  < �  ��� � o   � ����� 0 	something  ��  ��   �  f   � � � o      ���� 0 	something   �  � � � l  � ��� � ���   �   replace with space    � � � � &   r e p l a c e   w i t h   s p a c e �  � � � r   � � � � � n   � � � � � I   � ��� ����� 0 replacetext replaceText �  � � � m   � � � � � � �  & n b s p ; �  � � � m   � � � � � � �    �  ��� � o   � ����� 0 	something  ��  ��   �  f   � � � o      ���� 0 	something   �  � � � l  � ��� � ���   �   get rid of other HTML    � � � � ,   g e t   r i d   o f   o t h e r   H T M L �  � � � r   � � � � � n   � � � � � I   � ��� ����� 0 	striphtml 	stripHtml �  ��� � o   � ����� 0 	something  ��  ��   �  f   � � � o      ���� 0 	something   �  � � � l  � ��� � ���   �   replace common entities    � � � � 0   r e p l a c e   c o m m o n   e n t i t i e s �  � � � r   � � � � � n   � � � � � I   � ��� ����� 0 replacetext replaceText �  � � � m   � � � � � � � 
 & a m p ; �  � � � m   � � � � � � �  & �  ��� � o   � ����� 0 	something  ��  ��   �  f   � � � o      ���� 0 	something   �  � � � r   � � � � � n   � � � � � I   � ��� ����� 0 replacetext replaceText �  � � � m   � � � � � � �  & g t ; �  � � � m   � � � � � � �  > �  ��� � o   � ����� 0 	something  ��  ��   �  f   � � � o      ���� 0 	something   �  � � � r   � � � � n   � � � � I   ��� ����� 0 replacetext replaceText �  � � � m   � � � � � � �  & l t ; �  � � � m   �  � � � � �  < �  ��� � o   ���� 0 	something  ��  ��   �  f   � � � o      ���� 0 	something   �  � � � r   � � � n   � � � I  �� ����� 0 replacetext replaceText �  � � � m   � � � � �  & q u o t ; �  � � � m   � � � � �  " �  ��� � o  ���� 0 	something  ��  ��   �  f   � o      ���� 0 	something   �  � � � l �� � ���   � "  get rid of double new lines    � � � � 8   g e t   r i d   o f   d o u b l e   n e w   l i n e s �  �  � l ����   O I			set something to replaceText(return & return, return, something) of me    � � 	 	 	 s e t   s o m e t h i n g   t o   r e p l a c e T e x t ( r e t u r n   &   r e t u r n ,   r e t u r n ,   s o m e t h i n g )   o f   m e  �� r  $ o  "���� 0 	something   o      ���� 0 thebody theBody��  ��  ��   ;  l ))��������  ��  ��   	
	 Z  )V�� = )2 n  ). 1  *.��
�� 
pcls o  )*���� 0 
themessage 
theMessage m  .1��
�� 
outm k  5D  r  5> n  5: 1  6:��
�� 
tims o  56���� 0 
themessage 
theMessage o      ���� 0 thedate theDate �� r  ?D m  ?@��
�� boovtrue o      ���� 0 
isoutgoing 
isOutgoing��  ��   k  GV  r  GP  n  GL!"! 1  HL��
�� 
rTim" o  GH���� 0 
themessage 
theMessage  o      ���� 0 thedate theDate #��# r  QV$%$ m  QR��
�� boovfals% o      ���� 0 
isoutgoing 
isOutgoing��  
 &'& l WW��������  ��  ��  ' ()( r  W^*+* m  WZ,, �--  + o      ���� 0 toname toName) ./. r  _f010 m  _b22 �33  1 o      ���� 0 toaddr toAddr/ 454 Z  g�67����6 ? gr898 l gp:����: I gp��;�
�� .corecnte****       ****; n  gl<=< m  hl�~
�~ 
rcpt= o  gh�}�} 0 
themessage 
theMessage�  ��  ��  9 m  pq�|�|  7 k  u�>> ?@? r  u�ABA n  uCDC m  {�{
�{ 
emadD l u{E�z�yE n  u{FGF 4 v{�xH
�x 
rcptH m  yz�w�w G o  uv�v�v 0 
themessage 
theMessage�z  �y  B o      �u�u 0 torcpt toRcpt@ IJI Q  ��KLMK r  ��NON n  ��PQP 1  ���t
�t 
pnamQ o  ���s�s 0 torcpt toRcptO o      �r�r 0 toname toNameL R      �q�p�o
�q .ascrerr ****      � ****�p  �o  M r  ��RSR m  ��TT �UU  S o      �n�n 0 toname toNameJ V�mV r  ��WXW n  ��YZY 1  ���l
�l 
raddZ o  ���k�k 0 torcpt toRcptX o      �j�j 0 toaddr toAddr�m  ��  ��  5 [\[ l ���i�h�g�i  �h  �g  \ ]^] r  ��_`_ n  ��aba 1  ���f
�f 
sndrb o  ���e�e 0 
themessage 
theMessage` o      �d�d 0 
fromsender 
fromSender^ cdc Q  ��efge r  ��hih n  ��jkj 1  ���c
�c 
pnamk o  ���b�b 0 
fromsender 
fromSenderi o      �a�a 0 thefromname theFromNamef R      �`�_�^
�` .ascrerr ****      � ****�_  �^  g r  ��lml m  ��nn �oo  m o      �]�] 0 thefromname theFromNamed pqp r  ��rsr n  ��tut 1  ���\
�\ 
raddu o  ���[�[ 0 
fromsender 
fromSenders o      �Z�Z 0 thefromaddr theFromAddrq vwv l ���Y�X�W�Y  �X  �W  w xyx l ���Vz{�V  z #  sigh, can't save attachments   { �|| :   s i g h ,   c a n ' t   s a v e   a t t a c h m e n t sy }~} l ���U��U   0 *set atts to every attachment of theMessage   � ��� T s e t   a t t s   t o   e v e r y   a t t a c h m e n t   o f   t h e M e s s a g e~ ��� l ���T���T  �  repeat with att in atts   � ��� . r e p e a t   w i t h   a t t   i n   a t t s� ��� l ���S���S  �  	set nm to name of att   � ��� , 	 s e t   n m   t o   n a m e   o f   a t t� ��� l ���R���R  � " 	tell application "Maildrop"   � ��� 8 	 t e l l   a p p l i c a t i o n   " M a i l d r o p "� ��� l ���Q���Q  � P J		set theAtt to make new attachment at end of every attachment of theEmail   � ��� � 	 	 s e t   t h e A t t   t o   m a k e   n e w   a t t a c h m e n t   a t   e n d   o f   e v e r y   a t t a c h m e n t   o f   t h e E m a i l� ��� l ���P���P  �   		set name of theAtt to nm   � ��� 4 	 	 s e t   n a m e   o f   t h e A t t   t o   n m� ��� l ���O���O  � &  		set filePath to file of theAtt   � ��� @ 	 	 s e t   f i l e P a t h   t o   f i l e   o f   t h e A t t� ��� l ���N���N  �  		end tell   � ���  	 e n d   t e l l� ��� l ���M���M  �  	save att in filePath   � ��� * 	 s a v e   a t t   i n   f i l e P a t h� ��� l ���L���L  �  
end repeat   � ���  e n d   r e p e a t� ��� l ���K�J�I�K  �J  �I  � ��H� O  �f��� k  �e�� ��� r  ����� I ���G�F�
�G .corecrel****      � null�F  � �E��D
�E 
kocl� m  ���C
�C 
maIL�D  � o      �B�B 0 theemail theEmail� ��� r  ���� o  ���A�A 0 thebody theBody� n      ��� 1  ��@
�@ 
pBDY� o  ���?�? 0 theemail theEmail� ��� r  ��� o  �>�> 0 thefromname theFromName� n      ��� 1  
�=
�= 
frNM� o  
�<�< 0 theemail theEmail� ��� r  ��� o  �;�; 0 thefromaddr theFromAddr� n      ��� 1  �:
�: 
frAD� o  �9�9 0 theemail theEmail� ��� r  '��� o  �8�8 0 toname toName� n      ��� 1  "&�7
�7 
toNM� o  "�6�6 0 theemail theEmail� ��� r  (3��� o  (+�5�5 0 toaddr toAddr� n      ��� 1  .2�4
�4 
toAD� o  +.�3�3 0 theemail theEmail� ��� r  4?��� o  47�2�2 0 
isoutgoing 
isOutgoing� n      ��� 1  :>�1
�1 
seNT� o  7:�0�0 0 theemail theEmail� ��� r  @I��� o  @A�/�/ 0 
thesubject 
theSubject� n      ��� 1  DH�.
�. 
suBJ� o  AD�-�- 0 theemail theEmail� ��� r  JU��� o  JM�,�, 0 thedate theDate� n      ��� 1  PT�+
�+ 
DATE� o  MP�*�* 0 theemail theEmail� ��� I V]�)��(
�) .creaACTVnull���     maIL� o  VY�'�' 0 theemail theEmail�(  � ��&� I ^e�%��$
�% .coredelonull���     obj � o  ^a�#�# 0 theemail theEmail�$  �&  � m  �����                                                                                      @ alis    X  Macintosh HD               ��~�H+     )Maildrop.app                                                    q0��/c        ����  	                Applications    ���T      �Α�       )  (Macintosh HD :Applications: Maildrop.app    M a i l d r o p . a p p    M a c i n t o s h   H D    Applications/Maildrop.app   / ��  �H  �� 0 
themessage 
theMessage   o   # $�"�" $0 selectedmessages selectedMessages��   	 m     ��                                                                                  OPIM  alis    �  Macintosh HD               ��~�H+   �Microsoft Outlook.app                                           ���3k         ����  	                Microsoft Office 2011     ���T      �3͐     �   )  HMacintosh HD :Applications: Microsoft Office 2011: Microsoft Outlook.app  ,  M i c r o s o f t   O u t l o o k . a p p    M a c i n t o s h   H D    8Applications/Microsoft Office 2011/Microsoft Outlook.app  / ��  ��  ��    ��� l     �!� ��!  �   �  � ��� i     ��� I      ���� 0 	striphtml 	stripHtml� ��� o      �� 0 subject  �  �  � k     k�� ��� r     ��� n     � � 1    �
� 
txdl  1     �
� 
ascr� o      �� 0 od  �  r     m     �  < n       1    
�
� 
txdl 1    �
� 
ascr 	
	 r     n     2   �
� 
citm o    �� 0 subject   o      �� 0 subject  
  r     m     �   o      �� 0 newtext newText  r     m     �  > n       1    �
� 
txdl 1    �
� 
ascr  X    b�  k   , ]!! "#" r   , 1$%$ n   , /&'& 2  - /�
� 
citm' o   , -�� 0 anitem anItem% o      �� 0 newlist newList# (�( Z   2 ])*+�
) ?   2 9,-, l  2 7.�	�. I  2 7�/�
� .corecnte****       ****/ o   2 3�� 0 newlist newList�  �	  �  - m   7 8�� * r   < D010 b   < B232 o   < =�� 0 newtext newText3 n   = A454 4   > A�6
� 
citm6 m   ? @�� 5 o   = >� �  0 newlist newList1 o      ���� 0 newtext newText+ 787 =   G N9:9 l  G L;����; I  G L��<��
�� .corecnte****       ****< o   G H���� 0 newlist newList��  ��  ��  : m   L M���� 8 =��= r   Q Y>?> b   Q W@A@ o   Q R���� 0 newtext newTextA n   R VBCB 4   S V��D
�� 
citmD m   T U���� C o   R S���� 0 newlist newList? o      ���� 0 newtext newText��  �
  �  � 0 anitem anItem  o     ���� 0 subject   EFE r   c hGHG o   c d���� 0 od  H n      IJI 1   e g��
�� 
txdlJ 1   d e��
�� 
ascrF K��K L   i kLL o   i j���� 0 newtext newText��  � MNM l     ��������  ��  ��  N O��O i    PQP I      ��R���� 0 replacetext replaceTextR STS o      ���� 0 find  T UVU o      ���� 0 replace  V W��W o      ���� 0 subject  ��  ��  Q k     &XX YZY r     [\[ n     ]^] 1    ��
�� 
txdl^ 1     ��
�� 
ascr\ o      ���� 0 prevtids prevTIDsZ _`_ r    aba o    ���� 0 find  b n      cdc 1    
��
�� 
txdld 1    ��
�� 
ascr` efe r    ghg n    iji 2   ��
�� 
citmj o    ���� 0 subject  h o      ���� 0 subject  f klk l   ��������  ��  ��  l mnm r    opo o    ���� 0 replace  p n      qrq 1    ��
�� 
txdlr 1    ��
�� 
ascrn sts r    uvu b    wxw m    yy �zz  x o    ���� 0 subject  v o      ���� 0 subject  t {|{ r    #}~} o    ���� 0 prevtids prevTIDs~ n      � 1     "��
�� 
txdl� 1     ��
�� 
ascr| ��� l  $ $��������  ��  ��  � ���� L   $ &�� o   $ %���� 0 subject  ��  ��       ��������  � �������� 0 	striphtml 	stripHtml�� 0 replacetext replaceText
�� .aevtoappnull  �   � ****� ������������� 0 	striphtml 	stripHtml�� ����� �  ���� 0 subject  ��  � ������������ 0 subject  �� 0 od  �� 0 newtext newText�� 0 anitem anItem�� 0 newlist newList� 	������������
�� 
ascr
�� 
txdl
�� 
citm
�� 
kocl
�� 
cobj
�� .corecnte****       ****�� l��,E�O���,FO��-E�O�E�O���,FO E�[��l kh ��-E�O�j k ���l/%E�Y �j k  ���k/%E�Y h[OY��O���,FO�� ��Q���������� 0 replacetext replaceText�� ����� �  �������� 0 find  �� 0 replace  �� 0 subject  ��  � ���������� 0 find  �� 0 replace  �� 0 subject  �� 0 prevtids prevTIDs� ������y
�� 
ascr
�� 
txdl
�� 
citm�� '��,E�O���,FO��-E�O���,FO�%E�O���,FO�� �����������
�� .aevtoappnull  �   � ****� k    l��  ����  ��  ��  � ���� 0 
themessage 
theMessage� K����� ���������������� 0������������ Z�� f l x ~ � � � ��� � � � � � � � �������������,��2��������������T��~�}�|n�{��z�y�x�w�v�u�t�s�r�q�p�o�n
�� 
CMgs�� $0 selectedmessages selectedMessages
�� 
disp
�� .sysodlogaskr        TEXT
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
subj�� 0 
thesubject 
theSubject
�� 
msng
�� 
ctnt
�� 
TEXT�� 0 thebody theBody
�� 
pHtm�� 0 	something  
�� 
ret �� 0 replacetext replaceText�� 0 	striphtml 	stripHtml
�� 
pcls
�� 
outm
�� 
tims�� 0 thedate theDate�� 0 
isoutgoing 
isOutgoing
�� 
rTim�� 0 toname toName�� 0 toaddr toAddr
�� 
rcpt
�� 
emad�� 0 torcpt toRcpt
�� 
pnam��  ��  
� 
radd
�~ 
sndr�} 0 
fromsender 
fromSender�| 0 thefromname theFromName�{ 0 thefromaddr theFromAddr
�z 
maIL
�y .corecrel****      � null�x 0 theemail theEmail
�w 
pBDY
�v 
frNM
�u 
frAD
�t 
toNM
�s 
toAD
�r 
seNT
�q 
suBJ
�p 
DATE
�o .creaACTVnull���     maIL
�n .coredelonull���     obj ��m�i*�,E�O�jv  ��kl OhY hOJ�[��l kh  ��,E�O��  �E�Y hO��,�&E�O�a ,E ��E` O)_ a _ m+ E` O)a _ a %_ m+ E` O)a _ a %_ m+ E` O)a _ a %_ m+ E` O)a a _ m+ E` O)_ k+ E` O)a a _ m+ E` O)a  a !_ m+ E` O)a "a #_ m+ E` O)a $a %_ m+ E` O_ E�Y hO�a &,a '  �a (,E` )OeE` *Y �a +,E` )OfE` *Oa ,E` -Oa .E` /O�a 0,j j =�a 0k/a 1,E` 2O _ 2a 3,E` -W X 4 5a 6E` -O_ 2a 7,E` /Y hO�a 8,E` 9O _ 9a 3,E` :W X 4 5a ;E` :O_ 9a 7,E` <Oa = {*�a >l ?E` @O�_ @a A,FO_ :_ @a B,FO_ <_ @a C,FO_ -_ @a D,FO_ /_ @a E,FO_ *_ @a F,FO�_ @a G,FO_ )_ @a H,FO_ @j IO_ @j JU[OY��Uascr  ��ޭ