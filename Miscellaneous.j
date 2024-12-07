//===========================================================================
// *** 簡單雜項函數 ***
//===========================================================================

// --------------
// ** 數學函數 **
// --------------


// --------------
// ** 數值運算 **
// --------------
// 布爾值轉換為整數
function B2I takes boolean flag returns integer
    if flag then
       return 0
    endif
    return 1
endfunction

// 整數轉換為布爾值
function I2B takes integer n returns boolean
    return n != 0
endfunction

// 判斷整數是否在下限與上限之間
function IsInRangeInteger takes integer n, integer floor, integer ceiling returns boolean
    return n >= floor and n <= ceiling
endfunction

// 判斷實數是否在下限與上限之間
function IsInRangeReal takes real n, real floor, real ceiling returns boolean
    return n >= floor and n <= ceiling
endfunction

// 判斷單位是否在x坐標之間
function IsUnitInBetweenX takes unit u, real floor, real ceiling returns boolean
    local real x = GetUnitX(u)
    return x >= floor and x <= ceiling
endfunction

// 判斷單位是否在y坐標之間
function IsUnitInBetweenY takes unit u, real floor, real ceiling returns boolean
    local real y = GetUnitY(u)
    return y >= floor and y <= ceiling
endfunction

// 判斷單位是否在x坐標之間及y坐標之間
function IsUnitInBetweenXY takes unit u, real xbottom, real xtop, real ybottom, real ytop returns boolean
    local real x = GetUnitX(u)
    local real y = GetUnitY(u)
    return x >= xbottom and x <= xtop and y >= ybottom and y <= ytop
endfunction

// 兩坐標間的距離
function DistanceBetweenPointsXY takes real x1, real y1, real x2, real y2 returns real
    return SquareRoot((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2))
endfunction

// 從坐標(x1,y1)面向(x2,y2)的角度
function AngleBetweenPointsXY takes real x1, real y1, real x2, real y2 returns real
    return bj_RADTODEG * Atan2( y2 - y1, x2 - x1 )
endfunction

// 兩方向角間的夾角
function AngleBetweenAngles takes real angle1, real angle2 returns real
    local real r = ModuloReal( angle1 - angle2, 360.0 )
    if r <= 180.0 then
        return r
    endif
    return 360.0 - r
endfunction

// ----------------------
// ** 環境及可毀物函數 **
// ----------------------
// 初始化函數指定位置是否存在任何可毀物所用的區域
function IsPointExistsDestructablesInitRect takes nothing returns nothing
    set udg_cs_pointExistDestructablesRect = Rect(-64, -64, 64, 64)
endfunction

// 檢查指定位置是否在深水
function IsPointDeepWaterXY takes real x, real y returns boolean
    return not IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY) or IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
endfunction

// 取得區域內可毀物的數量
function CountDestructablesInRectEnum takes nothing returns nothing
    set udg_cs_rectCountDestructables = udg_cs_rectCountDestructables + 1
endfunction

function CountDestructablesInRect takes rect r returns integer
    set udg_cs_rectCountDestructables = 0
    call EnumDestructablesInRect(r, null, function CountDestructablesInRectEnum)
    return udg_cs_rectCountDestructables
endfunction

// 檢查指定可毀物是否在指定區域
function RectContainsDestructable takes rect r, destructable d returns boolean
    return RectContainsCoords(r, GetDestructableX(d), GetDestructableY(d))
endfunction

// 檢查指定可毀物是否橋樑
function IsDestructablesBridgeType takes destructable d returns boolean
    local integer id = GetDestructableTypeId(d)
    if id == 'ITib' or id == 'ITi2' or id == 'ITi4' or id == 'ITi3' or id == 'DTsb' or id == 'DTs1' or id == 'DTs3' or id == 'DTs2' or id == 'YT08' or id == 'YT32' or id == 'YT33' or id == 'YT09' or id == 'YT11' or id == 'YT35' or id == 'YT34' or id == 'YT10' or id == 'YT00' or id == 'YT24' or id == 'YT01' or id == 'YT25' or id == 'YT03' or id == 'YT27' or id == 'YT02' or id == 'YT26' or id == 'YT04' or id == 'YT28' or id == 'YT29' or id == 'YT05' or id == 'YT31' or id == 'YT07' or id == 'YT30' or id == 'YT06' or id == 'LT08' or id == 'LT09' or id == 'LT11' or id == 'LT10' or id == 'YT20' or id == 'YT44' or id == 'YT45' or id == 'YT21' or id == 'YT47' or id == 'YT23' or id == 'YT22' or id == 'YT46' or id == 'LTtc' or id == 'LTtx' or id == 'LTt4' or id == 'LTt2' or id == 'LTt0' or id == 'ATt1' or id == 'ATt0' or id == 'LTt3' or id == 'LTt1' or id == 'LTt5' or id == 'DTrf' or id == 'DTrx' or id == 'DTep' or id == 'YT48' or id == 'YT48' or id == 'YT49' or id == 'YT51' or id == 'YT50' or id == 'LT00' or id == 'LT01' or id == 'LT03' or id == 'LT02' or id == 'YT12' or id == 'YT36' or id == 'YT13' or id == 'YT37' or id == 'YT39' or id == 'YT15' or id == 'YT14' or id == 'YT38' then
       return true
    endif
    return false
endfunction

// 檢查指定位置是否存在任何可毀物，不考慮死亡的可毀物
function IsPointExistDestructablesXYEnum takes nothing returns nothing
    if GetWidgetLife(GetFilterDestructable()) > 0.405 then
       set udg_cs_pointExistDestructables = true
    endif
endfunction

function IsPointExistDestructablesXY takes real x, real y returns boolean
    set udg_cs_pointExistDestructables = false
    call MoveRectTo(udg_cs_pointExistDestructablesRect, x, y)
    call EnumDestructablesInRect(udg_cs_pointExistDestructablesRect, null, function IsPointExistDestructablesXYEnum)
    return udg_cs_pointExistDestructables
endfunction


// 檢查指定位置是否存在任何可毀物，考慮所有可毀物
function IsPointExistDestructablesXYExEnum takes nothing returns nothing
    set udg_cs_pointExistDestructables = true
endfunction

function IsPointExistDestructablesXYEx takes real x, real y returns boolean
    set udg_cs_pointExistDestructables = false
    call MoveRectTo(udg_cs_pointExistDestructablesRect, x, y)
    call EnumDestructablesInRect(udg_cs_pointExistDestructablesRect, null, function IsPointExistDestructablesXYExEnum)
    return udg_cs_pointExistDestructables
endfunction

// --------------
// ** 單位函數 **
// --------------
// 較準確的檢查單位是否已死亡或被移除
function IsUnitDead takes unit u returns boolean
    return IsUnitType(u, UNIT_TYPE_DEAD) or GetUnitState(u, UNIT_STATE_LIFE) < 0.41 or GetUnitTypeId(u) == 0
endfunction

// 較準確的檢查單位組的所有單位是否已死亡或被移除
function IsUnitGroupDeadEnum takes nothing returns nothing
    if not IsUnitDead(GetEnumUnit()) then
       set bj_isUnitGroupDeadResult = false
    endif
endfunction

function IsUnitGroupDead takes group g returns boolean
    local boolean wantDestroy = bj_wantDestroyGroup
    set bj_wantDestroyGroup = false

    set bj_isUnitGroupDeadResult = true
    call ForGroup(g, function IsUnitGroupDeadEnum)

    if (wantDestroy) then
        call DestroyGroup(g)
    endif
    return bj_isUnitGroupDeadResult
endfunction

// 檢查單位是否無敵，惟有不準確的情況，但聊勝於無
function IsUnitInvulnerable takes unit u returns boolean
    return GetUnitAbilityLevel(u, 'Avul') + GetUnitAbilityLevel(u, 'Aloc') + GetUnitAbilityLevel(u, 'Bvul') + GetUnitAbilityLevel(u, 'BHds') > 0
endfunction

// 檢查單位是否被擊暈，惟有不準確的情況，但聊勝於無
function IsUnitStun takes unit u returns boolean
    return GetUnitAbilityLevel(u, 'BPSE') + GetUnitAbilityLevel(u, 'BSTN') + GetUnitAbilityLevel(u, 'Bfrz') + GetUnitAbilityLevel(u, 'Bfre') + GetUnitAbilityLevel(u, 'BNsa') > 0
endfunction

// 檢查單位是否被控場
function IsUnitCrowdControl takes unit u returns boolean
    return GetUnitCurrentOrder(u) == 851973 or IsUnitStun(u) or LoadBoolean(udg_CustomCodeHashtable, GetHandleId(u), StringHash("IsUnitKnockingBack")) or LoadBoolean(udg_CustomCodeHashtable, GetHandleId(u), StringHash("IsUnitKnockingUp"))
endfunction

// 檢查單位是否免疫彈幕
function IsUnitImmuneBullet takes unit u returns boolean
    return false
endfunction

// 重置指定技能的冷卻時間
function UnitResetAbilityCooldown takes unit u, integer abilityId returns nothing
    local integer n = GetUnitAbilityLevel( u, abilityId )
    if n > 0 then
       call UnitRemoveAbility( u, abilityId )
       call UnitAddAbility( u, abilityId )
       call SetUnitAbilityLevel( u, abilityId, n )
    endif
endfunction

// 線段選擇單位
function GroupEnumUnitsInRangeOfSegment takes group whichgroup, real x1, real y1, real x2, real y2, real radius, boolexpr filter returns nothing
    local real dx = x2 - x1
    local real dy = y2 - y1
    local real L = dx * dx + dy * dy
    local real r = SquareRoot( dx * dx + dy * dy ) / 2 + radius
    local unit u
    local group g = CreateGroup()
    call GroupClear(whichgroup)
    call GroupEnumUnitsInRange(g, x1 + (dx / 2), y1 + (dy / 2), r * 1.25, filter)
    loop
        set u = FirstOfGroup(g)
        exitwhen u == null
        if L == 0 and IsUnitInRangeXY(u, x1, y1, radius) then
            call GroupAddUnit(whichgroup, u)
        else
            set r = ( (GetUnitX(u) - x1) * dx + (GetUnitY(u) - y1) * dy ) / (L)
            if r > 1 then
                if IsUnitInRangeXY(u, x2, y2, radius) then
                    call GroupAddUnit(whichgroup, u)
                endif
            elseif r < 0 then
                if IsUnitInRangeXY(u, x1, y1, radius) then
                    call GroupAddUnit(whichgroup, u)
                endif
            elseif IsUnitInRangeXY(u, x1 + r * dx, y1 + r * dy, radius) then
                call GroupAddUnit(whichgroup, u)
            endif
        endif
        call GroupRemoveUnit(g, u)
    endloop
    call DestroyGroup(g)
    set u = null
    set g = null
endfunction

// --------------
// ** 特效函數 **
// --------------
// 延時刪去特效
function DestroyEffectTimedDelay takes nothing returns nothing
    local timer t = GetExpiredTimer()
    call DestroyEffect( LoadEffectHandle(udg_CustomCodeHashtable, GetHandleId(t), StringHash("SpecialEffect")) )
    call FlushChildHashtable(udg_CustomCodeHashtable, GetHandleId(t))
    call DestroyTimer(t)
    set t = null
endfunction

// 延時刪去特效的實用函數
function DestroyEffectTimed takes effect whichEffect, real duration returns nothing
    local timer t = CreateTimer()
    call SaveEffectHandle(udg_CustomCodeHashtable, GetHandleId(t), StringHash("SpecialEffect"), whichEffect)
    call TimerStart(t, duration, false, function DestroyEffectTimedDelay)
    set t = null
endfunction

// 延時刪去閃電效果的
function DestroyLightningTimedDelay takes nothing returns nothing
    local timer t = GetExpiredTimer()
    call DestroyLightning(LoadLightningHandle(udg_PlayerCharacterSpellHashtable, GetHandleId(t), StringHash("DelayedLightning")))
    call FlushChildHashtable(udg_PlayerCharacterSpellHashtable, GetHandleId(t))
    call DestroyTimer(t)
    set t = null
endfunction

// 延時刪去閃電效果的實用函數
function DestroyLightningTimed takes string codeName, boolean checkVisibility, real x1, real y1, real x2, real y2, real duration returns nothing
    local timer t = CreateTimer()
    call SaveLightningHandle(udg_PlayerCharacterSpellHashtable, GetHandleId(t), StringHash("DelayedLightning"), AddLightning(codeName, checkVisibility, x1, y1, x2, y2))
    call TimerStart(t, duration, false, function DestroyLightningTimedDelay)
    set t = null
endfunction

function DestroyLightningTimedEx takes string codeName, boolean checkVisibility, real x1, real y1, real z1, real x2, real y2, real z2, real duration returns nothing
    local timer t = CreateTimer()
    call SaveLightningHandle(udg_PlayerCharacterSpellHashtable, GetHandleId(t), StringHash("DelayedLightning"), AddLightningEx(codeName, checkVisibility, x1, y1, z1, x2, y2, z2))
    call TimerStart(t, duration, false, function DestroyLightningTimedDelay)
    set t = null
endfunction
