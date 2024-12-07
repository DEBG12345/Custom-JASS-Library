//===========================================================================
// *** 位置移動函數 ***
//===========================================================================
// 這個與SetUnitPoisition的分別就是不會令單位停止
function SetUnitXY takes unit u, real x, real y returns nothing
    call SetUnitX(u, x)
    call SetUnitY(u, y)
endfunction

function SetUnitXYCheck takes unit u, real x, real y returns boolean
    local rect playableBound = GetPlayableMapRect()
    if x > GetRectMinX(playableBound) and x < GetRectMaxX(playableBound) and y > GetRectMinY(playableBound) and y < GetRectMaxY(playableBound) then
       call SetUnitX(u, x)
       call SetUnitY(u, y)
       return true
    else
       return false
    endif
    set playableBound = null
endfunction

function SetUnitXYBound takes unit u, real x, real y returns nothing
    local rect playableBound = GetPlayableMapRect()
    if x > GetRectMaxX(playableBound) then
       set x = GetRectMaxX(playableBound)
    else
       if x < GetRectMinX(playableBound) then
          set x = GetRectMinX(playableBound)
       endif
    endif
    if y > GetRectMaxY(playableBound) then
       set y = GetRectMaxY(playableBound)
    else
       if y < GetRectMinY(playableBound) then
          set y = GetRectMinY(playableBound)
       endif
    endif
    call SetUnitX(u, x)
    call SetUnitY(u, y)
    set playableBound = null
endfunction

function SetUnitXYBoundEx takes unit u, real x, real y returns nothing
    local rect worldBound = GetEntireMapRect()
    if x > GetRectMaxX(worldBound) then
       set x = GetRectMaxX(worldBound) - 0.1
    else
       if x < GetRectMinX(worldBound) then
          set x = GetRectMinX(worldBound) + 0.1
       endif
    endif
    if y > GetRectMaxY(worldBound) then
       set y = GetRectMaxY(worldBound) - 0.1
    else
       if y < GetRectMinY(worldBound) then
          set y = GetRectMinY(worldBound) + 0.1
       endif
    endif
    call SetUnitX(u, x)
    call SetUnitY(u, y)
    set worldBound = null
endfunction

function DisplaceUnitXY takes unit u, real distance, real angle returns nothing
    call SetUnitX(u, GetUnitX(u) + distance * Cos(angle * bj_DEGTORAD))
    call SetUnitY(u, GetUnitY(u) + distance * Sin(angle * bj_DEGTORAD))
endfunction

function DisplaceUnitXYPosition takes unit u, real distance, real angle returns nothing
    call SetUnitPosition(u, GetUnitX(u) + distance * Cos(angle * bj_DEGTORAD), GetUnitY(u) + distance * Sin(angle * bj_DEGTORAD))
endfunction

function DisplaceUnitXYCheck takes unit u, real distance, real angle returns boolean
    return SetUnitXYCheck(u, GetUnitX(u) + distance * Cos(angle * bj_DEGTORAD), GetUnitY(u) + distance * Sin(angle * bj_DEGTORAD))
endfunction

function DisplaceUnitXYBound takes unit u, real distance, real angle returns nothing
    call SetUnitXYBound(u, GetUnitX(u) + distance * Cos(angle * bj_DEGTORAD), GetUnitY(u) + distance * Sin(angle * bj_DEGTORAD))
endfunction

function DisplaceUnitXYBoundEx takes unit u, real distance, real angle returns nothing
    call SetUnitXYBoundEx(u, GetUnitX(u) + distance * Cos(angle * bj_DEGTORAD), GetUnitY(u) + distance * Sin(angle * bj_DEGTORAD))
endfunction
