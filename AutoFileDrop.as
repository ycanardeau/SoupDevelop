
#ifndef mod_AutoFileDrop

#include "shell32.as"
#include "kernel32.as"
#include "user32.as"

//Define
#define global GMEM_ZEROINIT	$00000040		//�������̓��e�� 0 �֏�����

#module mod_AutoFileDrop
//p1: �t�@�C�����h���b�v�����n���h��
//p2: �h���b�v����t�@�C���̃p�X
//p3: �E�B���h�E�̍��ォ��̃}�E�X�ʒuX
//p4: �E�B���h�E�̉E�ォ��̃}�E�X�ʒuY
//p5: �t�@�C���p�X�̌`�� 0(�K��)=Unicode(NT��p) 1=�ʏ�̕�����
#deffunc autodrop int p1,str p2,int p3,int p4,int p5
c1=20 + strlen(p2)*4			//DROPFILES�\���̂̃f�[�^�T�C�Y + ������
GlobalAlloc GMEM_ZEROINIT,c1	//�O���[�o���q�[�v�̃�������������
hMem=stat						//���������ꂽ�������A�h���X����
GlobalLock hMem					//�O���[�o���q�[�v�̈�̃����������b�N
p=stat							//�\���̂̐擪�̃A�h���X���擾
dupptr DropFiles,p,c1			//�\���̂̎擾
DropFiles.0=20					//DROPFILES�\���̂̃f�[�^�T�C�Y
DropFiles.1=p3					//�}�E�XX
DropFiles.2=p4					//�}�E�XY
DropFiles.3=1					//�|�C���^�擾ON

//Unicode���g�����g��Ȃ����w��[p5](�o�O�����邩��)
if p5=0{
	//NT�p
	DropFiles.4=1
	cnvstow DropFiles.5,p2
}else{
	//9x�p
	DropFiles.4=1				//NT�nOS�̊��ł͂�����0�ɂ���ƃp�X���擾�ł��Ȃ��炵��
								//9x�nOS�������Ă��Ȃ��̂ŏڍׂ͕s��
	s3=0						//������𐔒l�ɕϊ����邽�߂̕ϐ���int�^�ɕϊ�
	s1=p2						//�t�@�C���p�X��ϐ��ɂ���
	repeat strlen(p2)
		s2=strmid(s1,cnt,1)				//�ꕶ���������o��
		poke s3,0,s2					//������̂��擾
		memcpy DropFiles.5,s3,1,cnt*2	//�A�X�L�[�����R�[�h
		memset DropFiles.5,0,1,cnt*2+1	//NULL����
		locnt=cnt
	loop
	memset DropFiles.5,0,1,locnt*2+2	//�ꉞNULL������t��
}
PostMessage p1,WM_DROPFILES,hMem,0	//�h���b�v���b�Z�[�W���w�肳�ꂽ�E�B���h�E�ɑ��M
GlobalUnlock hMem					//�������̈�̃��b�N������
return 1
#global

#endif