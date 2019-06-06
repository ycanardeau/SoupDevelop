
// http://fs-cgi-basic01.freespace.jp/~hsp/ver3/hsp3.cgi?print+200512/05120010.txt
	
#ifndef __ACCELERATOR_AS__INCLUDED__
#define __ACCELERATOR_AS__INCLUDED__
	
#undef stop
#undef wait
#undef await
#undef onkey
	
#include "kernel32.as"
#include "user32.as"
#include "winmm.as"
	
#module mod_MessageLoop
	
	#deffunc MessageLoopInit
		dim msg, 7
		hTimerEvent = CreateEvent(null, true, false, null)
		timerId = 0
		return
	
	#define global stop goto *_stop@mod_MessageLoop
	*_stop
		ResetEvent hTimerEvent
		if (timerId != 0) {
			timeKillEvent timerId
			timerId = 0
		}
		goto *WaitForEvents
	
	#deffunc wait int _t
		ResetEvent hTimerEvent
		timerId = timeSetEvent(_t * 10, 10, hTimerEvent, 0, TIME_ONESHOT | TIME_CALLBACK_EVENT_SET)
		gosub *WaitForEvents
		return
	
	#deffunc await int _t,\
		local currentTime,\
		local timerLast,\
		local waitTime
		
		ResetEvent hTimerEvent
		currentTime = timeGetTime()
		if (timerLast == 0) {
			timerLast = currentTime
		}
		waitTime = timerLast + _t - currentTime
		timerLast = currentTime
		if (waitTime < 1) {
			SetEvent hTimerEvent
			timerId = 0
		} else {
			timerId = timeSetEvent(waitTime, 0, hTimerEvent, 0, TIME_ONESHOT | TIME_CALLBACK_EVENT_SET)
		}
		gosub *WaitForEvents
		return
	
	#deffunc UseAccelerator int _hAccelTable
		hAccel = _hAccelTable
		return
	
	#deffunc UnUseAccelerator
		curAccel = hAccel
		hAccel = null
		return curAccel
	
	//#define global onkey(%1, %2) oncmd %1 %2, WM_KEYDOWN
	
	*WaitForEvents
		MsgWaitForMultipleObjects 1, varptr(hTimerEvent), 0, INFINITE, QS_ALLINPUT
		if (stat == 1) {
			repeat
				PeekMessage varptr(msg), null, 0, 0, PM_REMOVE
				if (stat == false) {
					break
				}
				if (msg(1) == WM_QUIT) {
					end
				}
				if (hAccel != 0) {
					TranslateAccelerator msg(0), hAccel, varptr(msg)
					if (stat != 0) {
						continue
					}
				}
				TranslateMessage varptr(msg)
				DispatchMessage varptr(msg)
			loop
		} else : if (stat == 0) {
			if (timerId != 0) {
				timeKillEvent timerId
				timerId = 0
			}
			return
		}
		goto *WaitForEvents
	
#global
	
	MessageLoopInit
	
	
#module mod_Accelerator
	
	#deffunc AcceleratorInit int _accelerators
		sdim accel, _accelerators * 6
		nAccels = 0
		return
	
	#deffunc AcceleratorAdd int _optionalKey, int _key, int _cmd
		base = nAccels * 6
		nAccels++
		memexpand accel, nAccels * 6
		poke accel, base + 0, _optionalKey | 1
		wpoke accel, base + 2, _key
		wpoke accel, base + 4, _cmd
		return
	
	#deffunc AcceleratorApply
		UnUseAccelerator
		if (stat != 0) {
			DestroyAcceleratorTable stat
		}
		UseAccelerator CreateAcceleratorTable(varptr(accel), nAccels)
		return
	
#global
	
	AcceleratorInit
	
#endif
