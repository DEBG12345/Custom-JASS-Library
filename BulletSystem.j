//========================================================
//  *** 彈幕函數 ***
//
//  這類函數將更方便製作複雜的彈幕移動單位，
//  亦可增加代碼的可讀性。
//
//  推薦用於製作技能彈幕，特別適用於移動路徑複雜的彈幕
//========================================================
// 返回彈幕ID
function GetBulletID takes unit bullet returns integer
    return LoadInteger(udg_CustomCodeHashtable, GetHandleId(bullet), StringHash("BulletID"))
endfunction

// 彈幕佇列
function EnqueueBulletPointer takes integer n returns nothing
    set udg_BulletSystem_bulletPointerQ[udg_BulletSystem_bulletPointerQMax] = n
    set udg_BulletSystem_bulletPointerQMax = udg_BulletSystem_bulletPointerQMax + 1
endfunction

function DequeueBulletPointer takes nothing returns integer
    local integer i = 0
    local integer n = udg_BulletSystem_bulletPointerQ[0]
    loop
        exitwhen i > udg_BulletSystem_bulletPointerQMax
        set udg_BulletSystem_bulletPointerQ[i] = udg_BulletSystem_bulletPointerQ[i+1]
        set i = i + 1
    endloop
    set udg_BulletSystem_bulletPointerQMax = udg_BulletSystem_bulletPointerQMax - 1
    if udg_BulletSystem_bulletPointerQMax < 0 then
       set udg_BulletSystem_bulletPointerQMax = 0
    endif
    return n
endfunction

function ResetBulletPointerQueue takes nothing returns nothing
    local integer i = 0
    loop
        exitwhen i > udg_BulletSystem_bulletPointerQMax + 1
        set udg_BulletSystem_bulletPointerQ[i] = 0
        set i = i + 1
    endloop
    set udg_BulletSystem_bulletPointerQMax = 0
endfunction

// 實用函數，為彈幕設定額外計時器功能
// 若多於10個額外計時器功能，則額外的計時器功能無法使用
function AddBulletFunction takes unit bullet, code f, real timeout, boolean periodic returns nothing
    local integer i = GetBulletID(bullet)
    local integer j = 0
    local timer t
    if not IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       return
    endif
    if i > 0 and udg_BulletSystem_funcIndex[i] < 10 then
       if udg_BulletSystem_funcTimerA[i] == null then
          set udg_BulletSystem_funcTimerA[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerA[i]
       elseif udg_BulletSystem_funcTimerB[i] == null then
          set udg_BulletSystem_funcTimerB[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerB[i]
       elseif udg_BulletSystem_funcTimerC[i] == null then
          set udg_BulletSystem_funcTimerC[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerC[i]
       elseif udg_BulletSystem_funcTimerD[i] == null then
          set udg_BulletSystem_funcTimerD[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerD[i]
       elseif udg_BulletSystem_funcTimerE[i] == null then
          set udg_BulletSystem_funcTimerE[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerE[i]
       elseif udg_BulletSystem_funcTimerF[i] == null then
          set udg_BulletSystem_funcTimerF[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerF[i]
       elseif udg_BulletSystem_funcTimerG[i] == null then
          set udg_BulletSystem_funcTimerG[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerG[i]
       elseif udg_BulletSystem_funcTimerH[i] == null then
          set udg_BulletSystem_funcTimerH[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerH[i]
       elseif udg_BulletSystem_funcTimerI[i] == null then
          set udg_BulletSystem_funcTimerI[i] = CreateTimer()
          set t = udg_BulletSystem_funcTimerI[i]
       endif
       call TimerStart(t, timeout, periodic, f)
       call SaveUnitHandle(udg_CustomCodeHashtable, GetHandleId(t), StringHash("FunctionBullet"), bullet)
       set udg_BulletSystem_funcIndex[i] = udg_BulletSystem_funcIndex[i] + 1
       set t = null
    endif
endfunction

// 實用函數，移除指定的彈幕額外計時器功能
function RemoveBulletFunction takes unit bullet, integer id returns nothing
    local integer i = GetBulletID(bullet)
    local integer j = 0
    local timer t
    if not IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       return
    endif
    if i > 0 and id > 0 and id < 10 and id <= udg_BulletSystem_funcIndex[i] then
       if id == 1 then
          set t = udg_BulletSystem_funcTimerA[i]
          set udg_BulletSystem_funcTimerA[i] = null
       elseif id == 2 then
          set t = udg_BulletSystem_funcTimerB[i]
          set udg_BulletSystem_funcTimerB[i] = null
       elseif id == 3 then
          set t = udg_BulletSystem_funcTimerC[i]
          set udg_BulletSystem_funcTimerC[i] = null
       elseif id == 4 then
          set t = udg_BulletSystem_funcTimerD[i]
          set udg_BulletSystem_funcTimerD[i] = null
       elseif id == 5 then
          set t = udg_BulletSystem_funcTimerE[i]
          set udg_BulletSystem_funcTimerE[i] = null
       elseif id == 6 then
          set t = udg_BulletSystem_funcTimerF[i]
          set udg_BulletSystem_funcTimerF[i] = null
       elseif id == 7 then
          set t = udg_BulletSystem_funcTimerG[i]
          set udg_BulletSystem_funcTimerG[i] = null
       elseif id == 8 then
          set t = udg_BulletSystem_funcTimerH[i]
          set udg_BulletSystem_funcTimerH[i] = null
       elseif id == 9 then
          set t = udg_BulletSystem_funcTimerI[i]
          set udg_BulletSystem_funcTimerI[i] = null
       endif
       call PauseTimer(t)
       call DestroyTimer(t)
       call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(t), StringHash("FunctionBullet"))
       set udg_BulletSystem_funcIndex[i] = udg_BulletSystem_funcIndex[i] - 1
       set t = null
    endif
endfunction 

// 實用函數，移除所有彈幕額外計時器功能
// 同時重置額外計時器功能的索引數目
function RemoveAllBulletFunction takes unit bullet returns nothing
    local integer i = GetBulletID(bullet)
    if not IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       return
    endif
    if i > 0 and udg_BulletSystem_funcIndex[i] > 0 then
       if udg_BulletSystem_funcTimerA[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerA[i])
          call DestroyTimer(udg_BulletSystem_funcTimerA[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerA[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerA[i] = null
       endif
       if udg_BulletSystem_funcTimerB[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerB[i])
          call DestroyTimer(udg_BulletSystem_funcTimerB[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerB[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerB[i] = null
       endif
       if udg_BulletSystem_funcTimerC[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerC[i])
          call DestroyTimer(udg_BulletSystem_funcTimerC[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerC[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerC[i] = null
       endif
       if udg_BulletSystem_funcTimerD[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerD[i])
          call DestroyTimer(udg_BulletSystem_funcTimerD[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerD[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerD[i] = null
       endif
       if udg_BulletSystem_funcTimerE[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerE[i])
          call DestroyTimer(udg_BulletSystem_funcTimerE[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerE[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerE[i] = null
       endif
       if udg_BulletSystem_funcTimerF[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerF[i])
          call DestroyTimer(udg_BulletSystem_funcTimerF[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerF[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerF[i] = null
       endif
       if udg_BulletSystem_funcTimerG[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerG[i])
          call DestroyTimer(udg_BulletSystem_funcTimerG[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerG[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerG[i] = null
       endif
       if udg_BulletSystem_funcTimerH[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerH[i])
          call DestroyTimer(udg_BulletSystem_funcTimerH[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerH[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerH[i] = null
       endif
       if udg_BulletSystem_funcTimerI[i] != null then
          call PauseTimer(udg_BulletSystem_funcTimerI[i])
          call DestroyTimer(udg_BulletSystem_funcTimerI[i])
          call RemoveSavedHandle(udg_CustomCodeHashtable, GetHandleId(udg_BulletSystem_funcTimerI[i]), StringHash("FunctionBullet"))
          set udg_BulletSystem_funcTimerI[i] = null
       endif
    endif
    set udg_BulletSystem_funcIndex[i] = 0
endfunction

// 實用函數，暫停彈幕
function StopBullet takes unit bullet returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 then
       set udg_BulletSystem_bulletMove[i] = false
       set udg_BulletSystem_bulletSpeed[i] = 0.00
       set udg_BulletSystem_bulletAccel[i] = 0.00
       set udg_BulletSystem_bulletAngle[i] = 0.00
       set udg_BulletSystem_bulletAngleSpeed[i] = 0.00
       set udg_BulletSystem_bulletAngleAccel[i] = 0.00
    endif
endfunction

// 實用函數，移除所有彈幕功能
function ClearBullet takes unit bullet returns nothing
    local integer n = GetBulletID(bullet)
    set udg_BulletSystem_bullet[n] = null
    set udg_BulletSystem_bulletCollision[n] = false
    set udg_BulletSystem_collisionTrigger[n] = null
    call EnqueueBulletPointer( n )
    call StopBullet(bullet)
    call RemoveAllBulletFunction(bullet)
    call DestroyGroup(udg_BulletSystem_countedGroup[n])
    set udg_BulletSystem_countedGroup[n] = null
    call GroupRemoveUnit(udg_BulletSystem_bulletGroup, bullet)
    call RemoveSavedInteger(udg_CustomCodeHashtable, GetHandleId(bullet), StringHash("BulletID"))
endfunction

// 實用函數，判斷單位是否視為彈幕
function IsUnitBullet takes unit u returns boolean
    return IsUnitInGroup(u, udg_BulletSystem_bulletGroup)
endfunction

// 彈幕碰撞判定
function BulletCollisionGroupEnumFilter takes nothing returns boolean
    return IsUnitInRangeXY(GetFilterUnit(), udg_BulletSystem_bulletX, udg_BulletSystem_bulletY, udg_BulletSystem_collisionRadius[udg_BulletSystem_moveBulletIndex])
endfunction

function BulletCollisionSystem takes nothing returns nothing
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    call GroupClear(udg_BulletSystem_collisionGroup)
    call GroupEnumUnitsInRange(udg_BulletSystem_collisionGroup, udg_BulletSystem_bulletX, udg_BulletSystem_bulletY, udg_BulletSystem_collisionRadius[udg_BulletSystem_moveBulletIndex] + 300, Filter(function BulletCollisionGroupEnumFilter))
    loop
        set udg_BulletSystem_collisionEnumUnit = FirstOfGroup(udg_BulletSystem_collisionGroup)
        exitwhen udg_BulletSystem_collisionEnumUnit == null or udg_BulletSystem_bulletCollision[udg_BulletSystem_moveBulletIndex] == false
        if udg_BulletSystem_collisionTrigger[udg_BulletSystem_moveBulletIndex] != null and not IsUnitDead(udg_BulletSystem_collisionEnumUnit) and IsTriggerEnabled(udg_BulletSystem_collisionTrigger[udg_BulletSystem_moveBulletIndex]) and TriggerEvaluate(udg_BulletSystem_collisionTrigger[udg_BulletSystem_moveBulletIndex]) then
           set udg_BulletSystem_collisionBullet = udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex]
           call TriggerExecute(udg_BulletSystem_collisionTrigger[udg_BulletSystem_moveBulletIndex])
           call GroupAddUnit(udg_BulletSystem_countedGroup[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_collisionEnumUnit)
        endif
        call GroupRemoveUnit( udg_BulletSystem_collisionGroup, udg_BulletSystem_collisionEnumUnit )
    endloop
endfunction

// 彈幕移動方式
function MoveBulletPatternStandard takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
    set dx = udg_BulletSystem_bulletX + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Cos(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    set dy = udg_BulletSystem_bulletY + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex])
endfunction

function MoveBulletPatternRandom takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + GetRandomReal(-udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex], -udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = GetRandomReal(-udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
    set dx = udg_BulletSystem_bulletX + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Cos(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    set dy = udg_BulletSystem_bulletY + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex])
endfunction

function MoveBulletPatternSin takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    local real r = 0.00
    local real a = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
    set dx = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex]
    set dy = udg_BulletSystem_bulletAmplitude[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] * udg_BulletSystem_bulletTime[udg_BulletSystem_moveBulletIndex] * udg_BulletSystem_frequency)
    set r = SquareRoot(dx * dx + dy * dy)
    set a = Atan2(dy, dx) + udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD
    set dx = udg_BulletSystem_bulletX + r * Cos(a)
    set dy = udg_BulletSystem_bulletY + r * Sin(a)
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], bj_RADTODEG * Atan2(dy - udg_BulletSystem_bulletY, dx - udg_BulletSystem_bulletX))
endfunction

function MoveBulletPatternSinDecay takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    local real r = 0.00
    local real a = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
    set dx = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex]
    set dy = udg_BulletSystem_bulletAmplitude[udg_BulletSystem_moveBulletIndex] * Pow(2.718281828, -1 * udg_BulletSystem_bulletAmpDecay[udg_BulletSystem_moveBulletIndex] * udg_BulletSystem_bulletTime[udg_BulletSystem_moveBulletIndex] * udg_BulletSystem_frequency) * Sin(udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] * udg_BulletSystem_bulletTime[udg_BulletSystem_moveBulletIndex] * udg_BulletSystem_frequency)
    set r = SquareRoot(dx * dx + dy * dy)
    set a = Atan2(dy, dx) + udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD
    set dx = udg_BulletSystem_bulletX + r * Cos(a)
    set dy = udg_BulletSystem_bulletY + r * Sin(a)
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], bj_RADTODEG * Atan2(dy - udg_BulletSystem_bulletY, dx - udg_BulletSystem_bulletX))
endfunction

function MoveBulletPatternTrace takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    local real tx = GetUnitX(udg_BulletSystem_bulletTarget[udg_BulletSystem_moveBulletIndex])
    local real ty = GetUnitY(udg_BulletSystem_bulletTarget[udg_BulletSystem_moveBulletIndex])
    local real AngleDifference = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set AngleDifference = bj_RADTODEG * Atan2(ty - udg_BulletSystem_bulletY, tx - udg_BulletSystem_bulletX)
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
    if udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] > AngleDifference then
       set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] - udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
    else
	set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
    endif
    set dx = udg_BulletSystem_bulletX + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Cos(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    set dy = udg_BulletSystem_bulletY + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex])
endfunction

function MoveBulletPatternBounce takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    local real tx = 0.00
    local real ty = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
    set dx = udg_BulletSystem_bulletX + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Cos(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    set dy = udg_BulletSystem_bulletY + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    if IsTerrainPathable(dx, dy, PATHING_TYPE_FLYABILITY) then
       set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] + 180.00 + GetRandomReal(-udg_BulletSystem_bulletBounceDiff[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletBounceDiff[udg_BulletSystem_moveBulletIndex])
       set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = -udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
       set udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex] = -udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
       set dx = udg_BulletSystem_bulletX + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Cos(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
       set dy = udg_BulletSystem_bulletY + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    endif
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex])
endfunction

function MoveBulletPatternSpin takes nothing returns nothing
    local real dx = 0.00
    local real dy = 0.00
    local real tx = 0.00
    local real ty = 0.00
    set udg_BulletSystem_bulletX = GetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletY = GetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
    set tx = GetUnitX(udg_BulletSystem_bulletTarget[udg_BulletSystem_moveBulletIndex])
    set ty = GetUnitY(udg_BulletSystem_bulletTarget[udg_BulletSystem_moveBulletIndex])
    set udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleAccel[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletAngleSpeed[udg_BulletSystem_moveBulletIndex]
    set udg_BulletSystem_bulletDistance[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletDistance[udg_BulletSystem_moveBulletIndex] + udg_BulletSystem_bulletSpeed[udg_BulletSystem_moveBulletIndex]
    set dx = tx + udg_BulletSystem_bulletDistance[udg_BulletSystem_moveBulletIndex] * Cos(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    set dy = ty + udg_BulletSystem_bulletDistance[udg_BulletSystem_moveBulletIndex] * Sin(udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex] * bj_DEGTORAD)
    if dx > udg_BulletSystem_maxX then
       set dx = udg_BulletSystem_maxX
    elseif dx < udg_BulletSystem_minX then
       set dx = udg_BulletSystem_minX
    endif
    if dy > udg_BulletSystem_maxY then
       set dy = udg_BulletSystem_maxY
    elseif dy < udg_BulletSystem_minY then
       set dy = udg_BulletSystem_minY
    endif
    call SetUnitX(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dx)
    call SetUnitY(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], dy)
    call SetUnitFacing(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex], udg_BulletSystem_bulletAngle[udg_BulletSystem_moveBulletIndex])
endfunction

// 彈幕系統
function BulletUpdateSystem takes nothing returns nothing
    if udg_BulletSystem_bulletMax > 0 then
       set udg_BulletSystem_reset = true
       set udg_BulletSystem_moveBulletIndex = 1
       loop
           exitwhen udg_BulletSystem_moveBulletIndex > udg_BulletSystem_bulletMax
           if udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex] != null then
              set udg_BulletSystem_reset = false
              if GetUnitTypeId(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex]) == 0 then
                 call ClearBullet(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
              else
                 if udg_BulletSystem_bulletMove[udg_BulletSystem_moveBulletIndex] then
                    call TriggerExecute( udg_BulletSystem_bulletMoveTrigger[udg_BulletSystem_moveBulletIndex] )
                 endif
                 if udg_BulletSystem_bulletCollision[udg_BulletSystem_moveBulletIndex] then
                    call BulletCollisionSystem()
                 endif
                 set udg_BulletSystem_bulletTime[udg_BulletSystem_moveBulletIndex] = udg_BulletSystem_bulletTime[udg_BulletSystem_moveBulletIndex] + 1
                 if udg_BulletSystem_bulletTimeMax[udg_BulletSystem_moveBulletIndex] >= 0 and udg_BulletSystem_bulletTime[udg_BulletSystem_moveBulletIndex] >= udg_BulletSystem_bulletTimeMax[udg_BulletSystem_moveBulletIndex] then
                    call KillUnit(udg_BulletSystem_bullet[udg_BulletSystem_moveBulletIndex])
                 endif
              endif
           endif
           set udg_BulletSystem_moveBulletIndex = udg_BulletSystem_moveBulletIndex + 1
       endloop
       if udg_BulletSystem_reset then
          set udg_BulletSystem_bulletPointer = 1
          set udg_BulletSystem_bulletMax = 0
          call ResetBulletPointerQueue()
          call DestroyTimer(udg_BulletSystem_timer)
          set udg_BulletSystem_timer = null
       endif
    endif
endfunction

// 實用函數，使單位成為彈幕
function SetUnitBullet takes unit bullet returns nothing
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       return
    endif
    set udg_BulletSystem_bulletPointer = GetBulletID(bullet)
    if udg_BulletSystem_bulletPointer == 0 then
       if udg_BulletSystem_bulletPointerQMax > 0 then
          set udg_BulletSystem_bulletPointer = DequeueBulletPointer()
       else
          set udg_BulletSystem_bulletPointer = udg_BulletSystem_bulletMax + 1
          set udg_BulletSystem_bulletMax = udg_BulletSystem_bulletMax + 1
       endif
    endif
    set udg_BulletSystem_bullet[udg_BulletSystem_bulletPointer] = bullet
    set udg_BulletSystem_bulletTime[udg_BulletSystem_bulletPointer] = 0
    set udg_BulletSystem_bulletTimeMax[udg_BulletSystem_bulletPointer] = -1
    call GroupAddUnit(udg_BulletSystem_bulletGroup, bullet)
    call SaveInteger(udg_CustomCodeHashtable, GetHandleId(bullet), StringHash("BulletID"), udg_BulletSystem_bulletPointer)
    if udg_BulletSystem_countedGroup[udg_BulletSystem_bulletPointer] == null then
       set udg_BulletSystem_countedGroup[udg_BulletSystem_bulletPointer] = CreateGroup()
    endif
    if udg_BulletSystem_timer == null then
       set udg_BulletSystem_timer = CreateTimer()
       call TimerStart(udg_BulletSystem_timer, udg_BulletSystem_frequency, true, function BulletUpdateSystem)
    endif
endfunction

// 實用函數，開始移動彈幕，普通移動方式
function MoveBullet takes unit bullet, real speed, real acceleration, real angle, real omega, real alpha returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceleration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[1]
    endif
endfunction

// 實用函數，開始移動彈幕，隨機移動方式
function MoveBulletRandom takes unit bullet, real speed, real acceleration, real angle, real omega, real alpha returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceleration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[2]
    endif
endfunction

// 實用函數，開始移動彈幕，正弦移動方式
function MoveBulletSin takes unit bullet, real speed, real acceleration, real angle, real omega, real alpha, real amplitude returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceleration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletAmplitude[i] = amplitude
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[3]
    endif
endfunction

// 實用函數，開始移動彈幕，正弦移動方式，振幅會衰減
function MoveBulletSinDecay takes unit bullet, real speed, real acceleration, real angle, real omega, real alpha, real amplitude, real decay returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceleration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletAmplitude[i] = amplitude
       set udg_BulletSystem_bulletAmpDecay[i] = decay
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[4]
    endif
endfunction

// 實用函數，開始移動彈幕，追蹤單位移動方式
function MoveBulletTrace takes unit bullet, unit target, real speed, real acceleration, real angle, real omega, real alpha returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletTarget[i] = target
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceleration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[5]
    endif
endfunction

// 實用函數，開始移動彈幕，普通移動方式但遇上不可飛行區時時反彈
function MoveBulletBounce takes unit bullet, real speed, real acceleration, real angle, real omega, real alpha, real difference returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceleration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletBounceDiff[i] = difference
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[6]
    endif
endfunction

// 實用函數，開始移動彈幕，繞特定單位旋轉
function MoveBulletSpin takes unit bullet, unit target, real distance, real speed, real acceloration, real angle, real omega, real alpha returns nothing
    local integer i
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) then
       set i = GetBulletID(bullet)
       set udg_BulletSystem_bulletMove[i] = true
       set udg_BulletSystem_bulletDistance[i] = distance
       set udg_BulletSystem_bulletSpeed[i] = speed
       set udg_BulletSystem_bulletAccel[i] = acceloration
       set udg_BulletSystem_bulletAngle[i] = angle
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
       set udg_BulletSystem_bulletTarget[i] = target
       set udg_BulletSystem_bulletMoveTrigger[i] = udg_BulletSystem_bulletMoveType[7]
    endif
endfunction

// 實用函數，使時間與彈幕更新頻率同步
function ConvertBulletTime takes real time returns real
    return time / udg_BulletSystem_frequency
endfunction

// 實用函數，使彈幕更新頻率換算成真實時間
function ConvertRealTime takes real time returns real
    return time * udg_BulletSystem_frequency
endfunction

// 實用函數，返回彈幕是否正在移動的真假值
function IsBulletMoving takes unit bullet returns boolean
    local integer i = GetBulletID(bullet)
    return IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i]
endfunction

// 實用函數，設定彈幕移動時的速度
function SetBulletSpeed takes unit bullet, real speed returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletSpeed[i] = speed
    endif
endfunction

// 實用函數，設定彈幕移動時的加速度
function SetBulletAcceloration takes unit bullet, real acceloration returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletAccel[i] = acceloration
    endif
endfunction

// 實用函數，設定彈幕移動時的角度
function SetBulletAngle takes unit bullet, real angle returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletAngle[i] = angle
    endif
endfunction

// 實用函數，設定彈幕移動時的角速度
function SetBulletAngularVelocity takes unit bullet, real omega returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletAngleSpeed[i] = omega
    endif
endfunction

// 實用函數，設定彈幕移動時的角加速度
function SetBulletAngularAcceloration takes unit bullet, real alpha returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletAngleAccel[i] = alpha
    endif
endfunction

// 實用函數，設定彈幕移動時的震幅
function SetBulletAmplitude takes unit bullet, real amplitude returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletAmplitude[i] = amplitude
    endif
endfunction

// 實用函數，設定彈幕移動時的距離
function SetBulletDistance takes unit bullet, real distance returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletDistance[i] = distance
    endif
endfunction

// 實用函數，設定彈幕移動時的目標單位
function SetBulletTarget takes unit bullet, unit target returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       set udg_BulletSystem_bulletTarget[i] = target
    endif
endfunction

// 實用函數，設定彈幕達到一定更新執行次數後死亡
// 負數為無限
function SetBulletTimeMax takes unit bullet, integer n returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 then
       set udg_BulletSystem_bulletTimeMax[i] = n
    endif
endfunction

// 實用函數，返回彈幕移動時的速度
function GetBulletSpeed takes unit bullet returns real
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 and udg_BulletSystem_bulletMove[i] then
       return udg_BulletSystem_bulletSpeed[i]
    endif
    return 0.00
endfunction

// 實用函數，設定彈幕與單位碰撞時的執行的觸發
function TriggerRegisterBulletCollisionEvent takes trigger t, unit bullet, real radius returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 then
       set udg_BulletSystem_collisionRadius[i] = radius
       set udg_BulletSystem_bulletCollision[i] = true
       set udg_BulletSystem_collisionTrigger[i] = t
    endif
endfunction

function TriggerUnregisterBulletCollisionEvent takes trigger t, unit bullet returns nothing
    local integer i = GetBulletID(bullet)
    if IsUnitInGroup(bullet, udg_BulletSystem_bulletGroup) and i > 0 then
       set udg_BulletSystem_collisionRadius[i] = 0.00
       set udg_BulletSystem_bulletCollision[i] = false
       set udg_BulletSystem_collisionTrigger[i] = null
    endif
endfunction

// 實用函數，取得碰撞事件的碰撞彈幕
function GetBulletCollisionBullet takes nothing returns unit
    return udg_BulletSystem_collisionBullet
endfunction

// 實用函數，取得碰撞事件的碰撞單位
function GetBulletCollisionUnit takes nothing returns unit
    return udg_BulletSystem_collisionEnumUnit
endfunction


// 實用函數，在彈幕額外計時器功能中取得彈幕
function GetFunctionBullet takes timer t returns unit
    return LoadUnitHandle(udg_CustomCodeHashtable, GetHandleId(t), StringHash("FunctionBullet"))
endfunction

// 實用函數，清空彈幕碰撞單位組
function ClearCountedGroup takes unit bullet returns nothing
    local integer n = GetBulletID(bullet)
    call GroupClear(udg_BulletSystem_countedGroup[n])
endfunction

// 實用函數，檢查單位是否曾被彈幕碰撞
function IsUnitCollidedWithBullet takes unit u, unit bullet returns boolean
    return IsUnitInGroup(u, udg_BulletSystem_countedGroup[GetBulletID(bullet)])
endfunction

// 彈幕死亡，移除所有彈幕功能以釋放內存
function BulletDeathCondition takes nothing returns boolean
    return IsUnitBullet(GetDyingUnit())
endfunction

function BulletDeath takes nothing returns nothing
    call ClearBullet(GetDyingUnit())
endfunction

// 選取範圍內的彈幕
function GroupEnumBulletInRangeEnum takes nothing returns nothing
    if IsUnitBullet(GetEnumUnit()) and IsUnitInRangeXY(GetEnumUnit(), udg_BulletSystem_bulletEnumX, udg_BulletSystem_bulletEnumY, udg_BulletSystem_bulletEnumRadius) then
       call GroupAddUnit(udg_BulletSystem_bulletEnumGroup, GetEnumUnit())
    endif
endfunction

function GroupEnumBulletInRange takes group whichgroup, real x, real y, real radius returns nothing
    set udg_BulletSystem_bulletEnumGroup = whichgroup
    set udg_BulletSystem_bulletEnumX = x
    set udg_BulletSystem_bulletEnumY = y
    set udg_BulletSystem_bulletEnumRadius = radius
    call ForGroup(udg_BulletSystem_bulletGroup, function GroupEnumBulletInRangeEnum)
endfunction

// 初始化彈幕系統
function InitializeBulletSystem takes nothing returns nothing
    local trigger t = CreateTrigger()
    call TriggerRegisterAnyUnitEventBJ( t, EVENT_PLAYER_UNIT_DEATH )
    call TriggerAddCondition(t, Condition(function BulletDeathCondition))
    call TriggerAddAction(t, function BulletDeath)
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternStandard)
    set udg_BulletSystem_bulletMoveType[1] = t
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternRandom)
    set udg_BulletSystem_bulletMoveType[2] = t
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternSin)
    set udg_BulletSystem_bulletMoveType[3] = t
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternSinDecay)
    set udg_BulletSystem_bulletMoveType[4] = t
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternTrace)
    set udg_BulletSystem_bulletMoveType[5] = t
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternBounce)
    set udg_BulletSystem_bulletMoveType[6] = t
    set t = CreateTrigger()
    call TriggerAddAction(t, function MoveBulletPatternSpin)
    set udg_BulletSystem_bulletMoveType[7] = t
    set t = null
    call DestroyTimer(udg_BulletSystem_timer)
    set udg_BulletSystem_timer = null
endfunction
