.586P																;������� ������(��������� Pentium)
.MODEL FLAT, STDCALL												;������ ������, ���������� � �������
includelib ucrt.lib													; ���������� ������� ���������� C
includelib kernel32.lib												;������������: ����������� � kernel32
includelib "..\Debug\LP_asm01a.lib"

ExitProcess			PROTO	: DWORD											;�������� ������� ��� ��������� �������� Windows
system				PROTO C : DWORD											;����� cmd-�������
GetStdHandle		PROTO	: DWORD											;�������� handle ������ �� �������
printConsole		PROTO : DWORD, : DWORD									;����� ��������� ������ � �������
																			;(-10 ����,-11 ����� , -12 ������ ���������� ������)
WriteConsoleA		PROTO	: DWORD, : DWORD, : DWORD, : DWORD, : DWORD		;����� �� �������(����������� ������)
SetConsoleTitleA	PROTO	: DWORD										;������������� ��������� ���� ������� (ANSI)

getmin		PROTO : DWORD, : DWORD
getmax		PROTO : DWORD, : DWORD

SetConsoleOutputCP	PROTO : DWORD									;������������� ����� ������� ������� ������
																	;�������� ��� ���������
SetConsoleCP PROTO : DWORD											;������������� ����� �������� ������� �������� ��� ���������


.STACK 4096															;��������� �����

.CONST																;������� ��������
endl		equ 0ah													;������ �������� ������ (ANCI)
str_endl	byte endl, 0											; ������ "����� ������"
str_pause	db 'pause', 0
zero		byte 40 dup(0)


.DATA																;������� ������
Array			SDWORD	 -5, 5, 23, -1, 25, 8, -4, 22, 9, 0	
consoleTitle	BYTE	'My Console | ������������� 2-5 Win-1251',0				;82h, 0e1h, 0a5h, 0a2h, 0aeh, 0abh, 0aeh, 0a4h
text			BYTE	 "������� : getmax - getmin = "
string			BYTE	 40 dup(0)
min_string		BYTE	"����������� �������� = "
min_str			BYTE	 40 dup(0)
max_string		BYTE	"������������ �������� = "
max_str			BYTE	 40 dup(0)
array_string	BYTE	"������:",0

output1			BYTE	" "
array_str1		BYTE	 40 dup(0)
output2			BYTE	" "
array_str2		BYTE	 40 dup(0)
output3			BYTE	" "
array_str3		BYTE	 40 dup(0)
output4			BYTE	" "
array_str4		BYTE	 40 dup(0)
output5			BYTE	" "
array_str5		BYTE	 40 dup(0)
output6			BYTE	" "
array_str6		BYTE	 40 dup(0)
output7			BYTE	" "
array_str7		BYTE	 40 dup(0)
output8			BYTE	" "
array_str8		BYTE	 40 dup(0)
output9			BYTE	" "
array_str9		BYTE	 40 dup(0)
output10		BYTE	" "
array_str10		BYTE	 40 dup(0)


messageSize		DWORD	?
min				SDWORD	?
max				SDWORD	?
result			SDWORD	?


HW				=($ - text)											;���������� ����� ������ text
consolehandle	DWORD 0h											;��������� �������

.CODE																;������� ����

int_to_char PROC uses eax ebx ecx edi esi,
					pstr		: dword, ;����� ������ ����������
					intfield	: sdword ;����� ��� ��������������

	mov edi, pstr
	mov esi, 0
	mov eax, intfield												;����� -> � eax
	cdq
	test eax, eax													;��������� �������� ���
	mov ebx, 10;
	idiv ebx														;eax = eax/ebx, ������� � edx(������� ����� �� ������)
	jns plus														;���� ������������� �� ��������� �� plus jz plus
	neg eax
	neg edx
	mov cl, '-'														;������ ������ ���������� '-'
	mov [edi], cl													;������ ������ ���������� '-'
	inc edi															;++edi

plus:
	push dx															;�������� ->����
	inc esi															;++esi
	test eax, eax													;eax == 0?
	jz fin															;���� �� �� ������� �� fin
	cdq																;���� �������������� � eax �� edx
	idiv ebx  
	jmp plus														;����������� ������� �� plus

fin:																;���� � ecx ���-�� �� 0-�� �������� = ���-�� �������� ����������
	mov ecx, esi

write:																 ;���� ������ ����������
	pop bx															 ;������� �� ����� ->bx
	add bl,'0'														 ;������������ ������ � bl
	mov [edi], bl													 ;bl -> � ���������
	inc edi
	loop write														 ;���� (--ecx)>0 ������� �� write
	ret
	
int_to_char ENDP

main PROC															;����� ����� main
START :																;�����
		INVOKE SetConsoleOutputCP, 1251d
		INVOKE SetConsoleCP, 1251d
		;INVOKE printConsole, OFFSET text, OFFSET  consoleTitle			;����� � �������
		;INVOKE printConsole, OFFSET str_endl, OFFSET  consoleTitle		;����� � �������
		;------------------------------------------------
		mov ecx, lengthof Array
		mov esi, OFFSET Array
		;INVOKE printConsole, OFFSET array_string, OFFSET  consoleTitle
		;
		;INVOKE int_to_char, OFFSET array_str1, [esi]					;������ ������ �������
		;INVOKE printConsole, OFFSET output1, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str2, [esi]
		;INVOKE printConsole, OFFSET output2, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str3, [esi]
		;INVOKE printConsole, OFFSET output3, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str4, [esi]
		;INVOKE printConsole, OFFSET output4, OFFSET  consoleTitle
		;add esi, 4
		;
		;	INVOKE int_to_char, OFFSET array_str5, [esi]
		;INVOKE printConsole, OFFSET output5, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str6, [esi]
		;INVOKE printConsole, OFFSET output6, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str7, [esi]
		;INVOKE printConsole, OFFSET output7, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str8, [esi]
		;INVOKE printConsole, OFFSET output8, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str9, [esi]
		;INVOKE printConsole, OFFSET output9, OFFSET  consoleTitle
		;add esi, 4
		;
		;INVOKE int_to_char, OFFSET array_str10, [esi]
		;INVOKE printConsole, OFFSET output10, OFFSET  consoleTitle
		;add esi, 4															;����� ������ �������
		
OUTPUT:
	
		INVOKE int_to_char, OFFSET array_str1, [esi]
		INVOKE printConsole, OFFSET output1, OFFSET  consoleTitle
		
		
		add esi, 4
		
loop OUTPUT
		
		INVOKE printConsole, OFFSET str_endl, OFFSET  consoleTitle
		;------------------------------------------------
		INVOKE getmin, OFFSET Array, LENGTHOF Array							;���� ������ ������������ ��������
		mov min, eax
		INVOKE int_to_char, OFFSET min_str, min
		INVOKE printConsole, OFFSET min_string, OFFSET  consoleTitle		;����� � �������
		INVOKE printConsole, OFFSET str_endl, OFFSET  consoleTitle
		;------------------------------------------------
		INVOKE getmax, OFFSET Array, LENGTHOF Array							;���� ������ ������������� ��������
		mov max, eax
		INVOKE int_to_char, OFFSET max_str, max
		INVOKE printConsole, OFFSET max_string, OFFSET  consoleTitle		;����� � �������
		INVOKE printConsole, OFFSET str_endl, OFFSET  consoleTitle
		;------------------------------------------------
		sub eax, min														;���� ������� ����� ����������� � ������������
		mov result, eax
		INVOKE int_to_char, OFFSET string, result
		INVOKE printConsole, OFFSET text, OFFSET  consoleTitle		;����� � �������
		INVOKE printConsole, OFFSET str_endl, OFFSET  consoleTitle
		;------------------------------------------------
		push offset str_pause										;����� ��������� cmd-�������	
		call system													;system("pause")	
		push - 1													;��� �������� �������� Windows(�������� ExitProcess)
		call ExitProcess											;��� ����������� ����� ������� Windows


main ENDP															;����� ���������
;-----------------printConsole-------------------------------------------------------------
printConsole	 PROC uses eax ebx ecx edi esi,
						pstr	: dword,
						ptitle	: dword

	INVOKE SetConsoleTitleA, ptitle
	INVOKE GetStdHandle, -11
	mov esi, pstr													;������� ���������� ������� 
	mov edi, -1														;�� 0 �������
count:																;���������
	inc edi															;�� ������� ������
	cmp byte ptr [esi+edi], 0
	jne count														;���� �� 0-������, �� �����  count

	INVOKE WriteConsoleA, eax, pstr, edi, 0, 0						;����� � �������

	ret
printConsole ENDP



end main															;����� ������ main

		