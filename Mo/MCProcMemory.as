// �v���Z�X�������Ǘ��N���X

#ifndef __MODULE_CLASS_PROCESS_MEMORY_AS__
#define __MODULE_CLASS_PROCESS_MEMORY_AS__

#module MCPcMem mhWnd, midProc, mhProc, mpMem, mMSize

//------------------------------------------------
// �}�N��
//------------------------------------------------
#define mv modvar MCPcMem@

//------------------------------------------------
// �萔
//------------------------------------------------
#define true  1
#define false 0
#define NULL  0

//------------------------------------------------
// API �֐������̒萔
//------------------------------------------------
#define PROCESS_VM_OPERATION	0x0008
#define PROCESS_VM_READ			0x0010
#define PROCESS_VM_WRITE		0x0020
#define MEM_COMMIT				0x1000
#define MEM_RELEASE				0x8000
#define MEM_RESERVE				0x2000
#define PAGE_READWRITE			4

#define PROCESS_ALL_ACCESS		(0x000F0000 | 0x00100000 | 0x0FFF)

//------------------------------------------------
// WinAPI
//------------------------------------------------
#uselib "user32.dll"
#func   GetWindowThreadProcessId@MCPcMem "GetWindowThreadProcessId" int,int

#uselib "kernel32.dll"
#func   GetVersionEx@MCPcMem       "GetVersionExA"      int
#func   OpenProcess@MCPcMem        "OpenProcess"        int,int,int
#func   CloseHandle@MCPcMem        "CloseHandle"        int
#func   VirtualAllocEx@MCPcMem     "VirtualAllocEx"     int,int,int,int,int
#func   VirtualFreeEx@MCPcMem      "VirtualFreeEx"      int,int,int,int
#func   WriteProcessMemory@MCPcMem "WriteProcessMemory" int,int,int,int,int
#func   ReadProcessMemory@MCPcMem  "ReadProcessMemory"  int,int,int,int,int

//------------------------------------------------
// ���z�������̊m��
//------------------------------------------------
#modfunc PCM_alloc int nSize
	if ( mMSize || mhProc == NULL ) { return NULL }
	VirtualAllocEx mhProc, NULL, nSize, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE
	mpMem  = stat
	mMSize = nSize
	return mpMem
	
//------------------------------------------------
// ���z�������̉��
//------------------------------------------------
#modfunc PCM_free
	if ( mhProc == NULL || mMSize == 0 || mpMem == NULL ) { return false }
	VirtualFreeEx mhProc, mpMem, mMSize, MEM_RELEASE
	mpMem  = NULL
	mMSize = 0
	return true
	
//------------------------------------------------
// ���z�������ւ̏�������
//------------------------------------------------
#modfunc PCM_writeVM int ptr, int pValue, int nSize
	if ( pValue == NULL || mhProc == NULL ) { return false }
	WriteProcessMemory mhProc, ptr, pValue, nSize, NULL
	return
	
//------------------------------------------------
// �m�ۂ������z�������ւ̏�������( �|�C���^ )
//------------------------------------------------
#modfunc PCM_write int pValue, int nSize, int offset
	if ( (offset + nSize) > mMSize ) { return false }
	PCM_writeVM thismod, mpMem + offset, pValue, nSize
	return stat
	
//------------------------------------------------
// �m�ۂ������z�������ւ̏�������( �ϐ� )
//------------------------------------------------
#modfunc PCM_writeVar var p2, int nSize, int offset
	PCM_write thismod, varptr(p2), nSize, offset
	return stat
	
//------------------------------------------------
// ���z�������ւ̏�������( �l )
//------------------------------------------------
#define global PCM_writeInt(%1,%2=0,%3=0) val@MCPcMem = %2 : PCM_writeVar %1,val@MCPcMem,4,%3
#define global PCM_writeDouble(%1,%2,%3=0)val@MCPcMem = %2 : PCM_writeVar %1,val@MCPcMem,8,%3
#define global PCM_writeStr(%1,%2,%3=0)  sval@MCPcMem = %2 : PCM_writeVar %1,sval@MCPcMem,strlen(sval@MCPcMem) + 1,%3

//------------------------------------------------
// ���z����������̓ǂݍ���
//------------------------------------------------
#modfunc PCM_readVM int ptr, int pBuffer, int nSize
	if ( pBuffer == NULL || mhProc == NULL ) { return false }
	ReadProcessMemory mhProc, ptr, pBuffer, nSize, NULL
	return
	
//------------------------------------------------
// �m�ۂ������z����������̓ǂݍ���( �|�C���^ )
//------------------------------------------------
#modfunc PCM_read int pBuffer, int nSize, int offset
	PCM_readVM thismod, mpMem + offset, pBuffer, nSize
	return stat
	
//------------------------------------------------
// �m�ۂ������z����������̓ǂݍ���( �ϐ� )
//------------------------------------------------
#modfunc PCM_readVar var p2, int nSize, int offset
	PCM_read thismod, varptr(p2), nSize, offset
	return stat
	
//------------------------------------------------
// �m�ۂ������z�������̐擪�ւ̃|�C���^�𓾂�
//------------------------------------------------
#defcfunc PCM_getPtr mv
	return mpMem
	
//------------------------------------------------
// �m�ۂ����T�C�Y
//------------------------------------------------
#defcfunc PCM_getSize mv
	return mMSize
	
//------------------------------------------------
// �v���Z�X�n���h���𓾂�
//------------------------------------------------
#defcfunc PCM_hProc mv
	return mhProc
	
//------------------------------------------------
// [i] �R���X�g���N�^
//------------------------------------------------
#define global PCM_new(%1,%2) newmod %1, MCPcMem@, %2
#modinit int hWindow
	
	// �����o�ϐ��̏�����
	mhWnd = hWindow
	dim midProc
	dim mhProc
	dim mpMem
	dim mMSize
	
	// �v���Z�X�̃n���h���𓾂�
	GetWindowThreadProcessId mhWnd, varptr(midProc)
	OpenProcess PROCESS_ALL_ACCESS, false, midProc
	mhProc = stat
	
	return
	
//------------------------------------------------
// [i] �f�X�g���N�^
//------------------------------------------------
#define global PCM_delete(%1) delmod %1
#modterm
	// �������
	PCM_free thismod
	
	// �v���Z�X�n���h�������
	if ( mhProc ) { CloseHandle mhProc : mhProc = NULL }
	return
	
#global

#endif
