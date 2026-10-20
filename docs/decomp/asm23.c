// 0x8088ca0
int sub_8088CA0()
{
    sub_8005D88();
    return 0;
}


// 0x8089160
signed int __fastcall sub_8089160(int a1, int a2)
{
    _BYTE *v2; // r5
    int v3; // r1
    int v4; // r2

    sub_80301B2(0, a2);
    doPETEffect_8033fc0(0, v3, v4);
    submenu_loadSelectedEntryGfx(0);
    *v2 = 4;
    return 1;
}


// 0x808917c
signed int __fastcall sub_808917C(int a1, int a2, int a3)
{
    _BYTE *v3; // r5
    int v4; // r10
    __int16 *v5; // r7
    __int16 v6; // r0
    int v7; // r4
    signed int v8; // r7
    __int64 v9; // r0
    char *v10; // r3
    int v11; // r2
    char v12; // zf
    int v14; // [sp-Ch] [bp-20h]
    int v15; // [sp-8h] [bp-1Ch]
    int v16; // [sp-4h] [bp-18h]

    v5 = *(v4 + 4);
    if ( v5[1] & 0x200 )
    {
        PlaySoundEffect(131, 512, a3);
        *v3 = 8;
    }
    else
    {
        v6 = *v5;
        v7 = 0;
        while ( (byte_8089208[v7] & v6) != byte_8089208[v7] )
        {
            if ( ++v7 >= 8 )
                goto LABEL_12;
        }
        v8 = 0;
        if ( v6 & 2 )
            v8 = 16;
        v9 = GetCameraXYZ();
        v10 = &off_8089214 + 2 * v7 + v8;
        HIDWORD(v9) += v10[1] << 16;
        v14 = v9 + (*v10 << 16);
        v15 = HIDWORD(v9);
        v16 = v11;
        sub_80303FC(&v14);
        if ( !v12 )
            sprite_queueIndexedOamEntry(v7);
        SetCameraXYZ(v14, v15, v16);
LABEL_12:
        sub_8089280();
    }
    return 1;
}


// 0x8089234
int sub_8089234()
{
    int v0; // r1
    int v1; // r2

    camera_targetPlayer();
    doPETEffect_8033fc0(1, v0, v1);
    return 0;
}


// 0x8089244
int __fastcall submenu_loadSelectedEntryGfx(int a1)
{
    int v1; // r1
    int v2; // r2

    CopyWords(&byte_87DE44C[8 * a1], byte_30016F0, 0x20u);
    decompAndCopyData(byte_8089268);
    return PlaySoundEffect(127, v1, v2);
}


// 0x8089280
int sub_8089280()
{
    int v0; // r10
    char *v1; // r0

    v1 = byte_80892A4;
    if ( (**(v0 + oToolkit_CurFramePtr) & 0x1F) < 8 )
        v1 = byte_80892F4;
    scriptListRun_8001158(v1);
    return scriptListRun_8001158(byte_8089344);
}


// 0x8089370
signed int __fastcall __noreturn sprite_queueIndexedOamEntry(int a1)
{
    return sprite_queueOamEntryThunk_802FE28(*&byte_808938C[8 * a1], *&byte_808938C[8 * a1 + 4], 0, 1);
}


// 0x80895a8
int battleObject_runUpdateJumpTable_80895A8()
{
    unsigned __int8 *v0; // r5

    return (*(&jt_80895C0 + *v0))();
}


// 0x808964c
signed int owPlayer_beastOutFacingStep()
{
    _BYTE *v0; // r5
    int v1; // r0
    char v2; // zf
    char v3; // r0
    int v4; // r0
    int v5; // r0

    v1 = e_scenarioEffectStateCountersAnySet();
    if ( v2 )
    {
        sub_809E2AE(4);
        v3 = sub_809E2B8();
        sub_809E13C(v3);
        ai_setAIDataUnk18_8089CB0(0);
        *v0 = 116;
    }
    else
    {
        selectSoulWeaponCursorDir(v1);
        sub_8142990();
        v4 = getSoulWeaponCursorDir8();
        sub_809E2AE(v4);
        v5 = sub_809E2B8();
        sub_809E13C(byte_80896A8[v5]);
        battle_initBeastSpAIChipQueues();
        e_setScenarioEffectStateB(0);
        cutscene_startCameraScript();
        *v0 = 4;
    }
    return 1;
}


// 0x80896b0
signed int __fastcall sub_80896B0(int a1, int a2, int a3, int a4)
{
    _BYTE *v4; // r5

    if ( !v4[19] )
    {
        sub_8089CF8(v4[19], a2, a3, a4);
        *v4 = 12;
    }
    return 1;
}


// 0x80896c4
signed int sub_80896C4()
{
    _BYTE *v0; // r5

    if ( !v0[19] )
        *v0 = 12;
    return 1;
}


// 0x80896d4
signed int __fastcall battle_scenarioEffectInputStep(int a1, int a2, int a3)
{
    _BYTE *v3; // r5
    signed int v4; // r0
    char v5; // zf

    v4 = battleObject_scenarioEffectInputHandler_8089704(a1, a2, a3);
    if ( !v5 )
    {
        if ( v4 == 1 )
        {
            cutscene_startCameraScript();
        }
        else if ( v4 == 2 )
        {
            *v3 = 16;
        }
        else
        {
            camera_startCutsceneScript();
            sub_80468EC(1);
            *v3 = 24;
        }
    }
    return 1;
}


// 0x8089704
signed int __fastcall battleObject_scenarioEffectInputHandler_8089704(int a1, int a2, int a3)
{
    int v3; // r10
    __int16 v4; // r7
    signed int v5; // r4
    int v6; // r0
    int v7; // r1
    int v8; // r2
    char v9; // zf
    int v10; // r1
    int v11; // r2
    __int16 v12; // r7
    int v13; // r0
    unsigned __int8 v14; // vf
    int v15; // r0
    int v16; // r0

    v4 = *(*(v3 + oToolkit_JoypadPtr) + 2);
    v5 = 0;
    if ( v4 & 1 )
    {
        v6 = battle_getScenarioEffectStateField_81421D0();
        battle_checkScenarioEffectActive_8142190(v6);
        if ( v9 )
        {
            PlaySoundEffect(105, v7, v8);
        }
        else
        {
            sub_8142A84();
            if ( !v9 )
            {
                PlaySoundEffect(103, v10, v11);
                v5 = 2;
            }
        }
    }
    else if ( v4 & 2 )
    {
        PlaySoundEffect(104, a2, a3);
        v5 = 3;
    }
    else
    {
        v12 = *(*(v3 + oToolkit_JoypadPtr) + 4);
        if ( v12 & 0x40 )
        {
            PlaySoundEffect(102, a2, a3);
            v13 = battle_getScenarioEffectStateField_81421D0();
            v14 = __OFSUB__(v13, 1);
            v15 = v13 - 1;
            if ( (v15 < 0) ^ v14 )
                v15 = 3;
            e_setScenarioEffectStateB(v15);
            v5 = 1;
        }
        else if ( v12 & 0x80 )
        {
            PlaySoundEffect(102, a2, a3);
            v16 = battle_getScenarioEffectStateField_81421D0() + 1;
            if ( v16 >= 4 )
                v16 = 0;
            e_setScenarioEffectStateB(v16);
            v5 = 1;
        }
    }
    return v5;
}


// 0x8089792
signed int __fastcall sub_8089792(int a1)
{
    _BYTE *v1; // r5
    int v2; // r0

    v2 = battle_getScenarioEffectStateField_81421D0();
    sub_8089CA4(v2 + 2);
    *v1 = 20;
    return 1;
}


// 0x80897a6
signed int battleObject_beastOut_checkOrInit_80897A6()
{
    _BYTE *v0; // r5
    char v1; // zf
    int v2; // r0

    if ( !v0[19] )
    {
        chatbox_mask_eFlags2009F38(128);
        if ( v1 )
        {
            if ( chatbox_GetState_8045F4C() )
            {
                battle_initBeastSpAIChipQueues();
                *v0 = 12;
            }
            else
            {
                ow_freeMapObjectTrio();
                v2 = battle_getScenarioEffectStateField_81421D0();
                sub_81421B2(v2);
                sub_80468EC(1);
                ai_setAIDataUnk18_8089CB0(10);
                *v0 = 32;
            }
        }
    }
    return 1;
}


// 0x80897e8
signed int battle_tickChipLockoutAndFade_80897E8()
{
    _BYTE *v0; // r5
    char v1; // zf

    chatbox_mask_eFlags2009F38(128);
    if ( v1 )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v1 )
        {
            engine_setScreeneffect(4, 255);
            *v0 = 36;
        }
    }
    return 1;
}


// 0x8089808
signed int sub_8089808()
{
    _BYTE *v0; // r5
    char v1; // zf

    IsPaletteFadeActive();
    if ( !v1 )
    {
        engine_setScreeneffect(0, 16);
        ai_setAIDataUnk18_8089CB0(5);
        *v0 = 40;
    }
    return 1;
}


// 0x8089826
signed int __fastcall battle_chipLockoutExpiredSetState(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8142BB6();
        *v1 = 44;
    }
    return 1;
}


// 0x808983a
signed int battle_initBeastOutAiTurn_808983A()
{
    _BYTE *v0; // r5
    int v1; // r7
    char v2; // zf

    IsPaletteFadeActive();
    if ( !v2 )
    {
        battle_initAIChipQueueSlot3();
        *(v1 + 12) = battleScenarioEffect_isActive_814216E();
        ai_setAIDataUnk18_8089CB0(30);
        *v0 = 48;
    }
    return 1;
}


// 0x808985a
signed int battle_tickBeastSp_808985A()
{
    _BYTE *v0; // r5
    int v1; // r7
    int v2; // r4
    char v3; // zf

    v2 = battle_countAliveActorsOnTeam_8142C20(0);
    if ( battleScenarioEffect_isActive_814216E() == v2 )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v3 )
        {
            if ( battleScenarioEffect_isActive_814216E() == *(v1 + 12) )
            {
                sub_8142ADA();
                if ( v3 )
                {
                    camera_startCutsceneScript();
                    *v0 = 24;
                }
                else
                {
                    *v0 = 60;
                }
            }
            else
            {
                *v0 = 52;
            }
        }
    }
    return 1;
}


// 0x808989c
signed int __fastcall sub_808989C(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8089CA4(7);
        *v1 = 56;
    }
    return 1;
}


// 0x80898b2
signed int battleObject_beastModeAiPhaseInit_80898B2()
{
    _BYTE *v0; // r5
    char v1; // zf

    chatbox_mask_eFlags2009F38(128);
    if ( v1 )
    {
        battleScenarioEffect_isActive_814216E();
        if ( v1 )
        {
            ai_setAIDataUnk18_8089CB0(30);
            *v0 = 92;
        }
        else
        {
            sub_8142ADA();
            if ( v1 )
            {
                camera_startCutsceneScript();
                *v0 = 24;
            }
            else
            {
                *v0 = 60;
            }
        }
    }
    return 1;
}


// 0x80898e8
signed int __fastcall sub_80898E8(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8142BFA();
        *v1 = 64;
    }
    return 1;
}


// 0x80898fc
signed int ai_setStateIfTeamAlive()
{
    _BYTE *v0; // r5

    if ( battle_countAliveActorsOnTeam_8142C20(16) )
    {
        sub_8089CA4(8);
        ai_setAIDataUnk18_8089CB0(30);
        *v0 = 68;
    }
    return 1;
}


// 0x808991c
signed int owPlayer_cutsceneTurnAnimStep()
{
    _BYTE *v0; // r5
    char v1; // zf
    int v2; // r0
    int v3; // r0

    chatbox_mask_eFlags2009F38(128);
    if ( v1 )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v1 )
        {
            v2 = sub_8142B58();
            sub_809E2AE(v2);
            v3 = sub_809E2B8();
            sub_809E13C(byte_8089958[v3]);
            camera_startCutsceneScript();
            ai_setAIDataUnk18_8089CB0(30);
            *v0 = 72;
        }
    }
    return 1;
}


// 0x8089960
signed int sub_8089960()
{
    _BYTE *v0; // r5
    char v1; // zf

    if ( !v0[19] )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v1 )
        {
            engine_setScreeneffect(4, 255);
            *v0 = 76;
        }
    }
    return 1;
}


// 0x808997e
signed int sub_808997E()
{
    _BYTE *v0; // r5
    char v1; // zf

    IsPaletteFadeActive();
    if ( !v1 )
    {
        engine_setScreeneffect(0, 16);
        ai_setAIDataUnk18_8089CB0(5);
        *v0 = 80;
    }
    return 1;
}


// 0x808999c
signed int __fastcall sub_808999C(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf
    int v3; // r0
    int v4; // r0

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        v3 = e_popScenarioEffectEntry();
        if ( v3 && (ow_dealDamageToCurrentNavi(v3), v4 = getPETNaviSelect(), GetMaxAndCurHPForCurPETNavi_80010D4(v4)) )
        {
            ai_setAIDataUnk18_8089CB0(30);
        }
        else
        {
            e_clearScenarioEffectStateFlag();
            ai_setAIDataUnk18_8089CB0(30);
            *v1 = 84;
        }
    }
    return 1;
}


// 0x80899d8
signed int sub_80899D8()
{
    _BYTE *v0; // r5
    char v1; // zf

    IsPaletteFadeActive();
    if ( !v1 )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v1 )
        {
            sub_8142BF4();
            *v0 = 88;
        }
    }
    return 1;
}


// 0x80899f2
signed int sub_80899F2()
{
    _BYTE *v0; // r5
    int v1; // r4

    v1 = battle_countAliveActorsOnTeam_8142C20(0);
    if ( battleScenarioEffect_isActive_814216E() == v1 )
    {
        camera_startCutsceneScript();
        *v0 = 24;
    }
    return 1;
}


// 0x8089a10
signed int __fastcall battleObject_beastOutActivate_8089A10(int a1)
{
    int v1; // r5
    char v2; // zf
    char (*v3)[8]; // r0

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        v3 = off_8089A40[GetSoulWeaponsMapIndex()];
        *(v1 + 60) = v3;
        sub_8036F98(v3);
        *(v1 + 19) = 1;
        ai_setAIDataUnk18_8089CB0(60);
        *v1 = 96;
    }
    return 1;
}


// 0x8089a60
signed int __fastcall battle_handleChipLockoutTransition_8089A60(int a1)
{
    _BYTE *v1; // r5
    int v2; // r7
    int v3; // r10
    char v4; // zf
    int v5; // r0
    int v6; // r1
    int v7; // r2
    int v8; // r0
    int v9; // r1
    int v10; // r2

    battle_tickChipLockout_8089CB4();
    if ( !v4 )
    {
        v5 = battle_getSoulWeaponBase_81427CE();
        ClearEventFlag(v5);
        *(v2 + 16) = e_scenarioEffectStateCountersAnySet();
        e_clearScenarioEffectValue();
        SetEventFlagFromImmediate(7, 64);
        ClearEventFlagFromImmediate(2, 37);
        *(*(v3 + oToolkit_GameStatePtr) + oGameState_SavedByte) = 0;
        TestEventFlagFromImmediate(0, 40);
        if ( v4 && GetSoulWeaponsMapIndex() < 6 )
        {
            sprite_loadBeastSpAnims();
            PlaySoundEffect(356, v6, v7);
            v8 = sub_8036E44();
            sub_8036E78(v8, v9, v10);
        }
        ai_setAIDataUnk18_8089CB0(30);
        *v1 = 100;
    }
    return 1;
}


// 0x8089aca
signed int __fastcall ai_chipLockoutWaitState(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8089CA4(12);
        ai_setAIDataUnk18_8089CB0(30);
        *v1 = 104;
    }
    return 1;
}


// 0x8089ae8
signed int battle_handleBeastOutStep_8089AE8()
{
    _BYTE *v0; // r5
    int v1; // r7
    char v2; // zf
    char v3; // r0

    chatbox_mask_eFlags2009F38(128);
    if ( v2 )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v2 )
        {
            sub_8036FAA();
            v0[19] = 0;
            sub_809E2AE(4);
            v3 = sub_809E2B8();
            sub_809E13C(v3);
            if ( *(v1 + 16) )
            {
                ai_setAIDataUnk18_8089CB0(30);
                *v0 = 108;
            }
            else
            {
                ai_setAIDataUnk18_8089CB0(0);
                *v0 = 112;
            }
        }
    }
    return 1;
}


// 0x8089b2e
signed int __fastcall battle_tickChipLockoutLockoutAndAttack_8089B2E(int a1)
{
    _BYTE *v1; // r5
    int v2; // r7
    char v3; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v3 )
    {
        chatbox_8045EDC(2, *(v2 + 16));
        sub_8089CA4(17);
        ai_setAIDataUnk18_8089CB0(30);
        *v1 = 112;
    }
    return 1;
}


// 0x8089b54
signed int owPlayer_handleBeastSpawnTransition_8089B54()
{
    _BYTE *v0; // r5
    char v1; // zf
    char v2; // r0

    chatbox_mask_eFlags2009F38(128);
    if ( v1 )
    {
        battle_tickChipLockout_8089CB4();
        if ( !v1 )
        {
            sub_809E2AE(4);
            v2 = sub_809E2B8();
            sub_809E13C(v2);
            reqBBS_clearFlag_8140A0C();
            *v0 = 24;
        }
    }
    return 1;
}


// 0x8089b7e
signed int __fastcall sub_8089B7E(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8089CA4(0);
        *v1 = 120;
    }
    return 1;
}


// 0x8089b94
signed int sub_8089B94()
{
    int v0; // r5
    char v1; // zf

    chatbox_mask_eFlags2009F38(128);
    if ( !v1 )
        return 1;
    *(v0 + 8) = 1;
    return 0;
}


// 0x8089baa
signed int __fastcall battle_waitChipLockoutEnd(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8089CA4(13);
        *v1 = -128;
    }
    return 1;
}


// 0x8089bc0
signed int ai_event745OnceInit()
{
    _BYTE *v0; // r5
    char v1; // zf

    chatbox_mask_eFlags2009F38(128);
    if ( v1 )
    {
        SetEventFlagFromImmediate(7, 69);
        v0[8] = 0;
        ai_setAIDataUnk18_8089CB0(30);
        *v0 = 28;
    }
    return 1;
}


// 0x8089be4
signed int __fastcall battle_aiChipLockoutWait(int a1)
{
    _BYTE *v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( !v2 )
    {
        sub_8089CA4(14);
        *v1 = -120;
    }
    return 1;
}


// 0x8089bfa
signed int ai_setupStateTimer1C()
{
    _BYTE *v0; // r5
    char v1; // zf

    chatbox_mask_eFlags2009F38(128);
    if ( v1 )
    {
        v0[8] = 0;
        ai_setAIDataUnk18_8089CB0(30);
        *v0 = 28;
    }
    return 1;
}


// 0x8089c16
signed int beastOverworldAi_decideTransformOrIdle_8089C16()
{
    _BYTE *v0; // r5
    int v1; // r0
    char v2; // r0
    char v3; // zf

    if ( !v0[19] )
    {
        v0[8] = 1;
        v1 = getPETNaviSelect();
        if ( GetMaxAndCurHPForCurPETNavi_80010D4(v1) )
        {
            v2 = sub_809E2B8();
            sub_809E13C(v2);
            ai_setAIDataUnk18_8089CB0(30);
            battleScenarioEffect_isActive_814216E();
            if ( !v3 && (e_scenarioEffectStateCountersAnySet(), v3) )
            {
                *v0 = 124;
            }
            else
            {
                ai_setAIDataUnk18_8089CB0(0);
                *v0 = 28;
            }
        }
        else
        {
            v0[8] = 0;
            if ( !getPETNaviSelect() )
                sub_809E13C(58);
            ai_setAIDataUnk18_8089CB0(30);
            *v0 = -124;
        }
    }
    return 1;
}


// 0x8089c78
signed int __fastcall sub_8089C78(int a1)
{
    int v1; // r5
    char v2; // zf

    battle_tickChipLockout_8089CB4();
    if ( v2 )
        return 1;
    sub_8036FAA();
    *(v1 + 19) = 0;
    *(v1 + 52) = &byte_80894D4[16 * GetSoulWeaponsMapIndex()];
    return 0;
}


// 0x8089ca4
void __fastcall sub_8089CA4(int a1)
{
    int v1; // r5

    chatbox_runScript(*(v1 + 48), a1);
}


// 0x8089cb0
int __fastcall ai_setAIDataUnk18_8089CB0(int result)
{
    int v1; // r5

    *(v1 + 24) = result;
    return result;
}


// 0x8089cb4
signed int battle_tickChipLockout_8089CB4()
{
    int v0; // r5
    int v1; // r0
    unsigned __int8 v2; // vf
    int v3; // r0

    v1 = *(v0 + 24);
    v2 = __OFSUB__(v1, 1);
    v3 = v1 - 1;
    if ( (v3 < 0) ^ v2 )
        return 1;
    *(v0 + 24) = v3;
    return 0;
}


// 0x8089cc4
signed int cutscene_startCameraScript()
{
    int v0; // r5
    signed int result; // r0

    battleObject_scenarioEffectInitPlayerOffsetMatrix_81429CA();
    *(v0 + 60) = byte_8089480;
    sub_8036F98(byte_8089480);
    result = 1;
    *(v0 + 19) = 1;
    return result;
}


// 0x8089cdc
char *camera_startCutsceneScript()
{
    int v0; // r5

    *(v0 + 60) = byte_808948A;
    sub_8036F98(byte_808948A);
    *(v0 + 19) = 1;
    ow_freeMapObjectTrio();
    return battle_initAIChipQueueSlot3();
}


// 0x8089cf8
int __fastcall sub_8089CF8(int a1, int a2, int a3, int a4)
{
    int v4; // r5
    _DWORD *v5; // r7
    signed int v6; // r4
    int result; // r0

    v6 = 0;
    do
    {
        result = sub_8004822(18, a2, a3, a4);
        *v5 = v4;
        ++v5;
        ++v6;
    }
    while ( v6 < 3 );
    return result;
}


// 0x8089d0e
int ow_freeMapObjectTrio()
{
    _DWORD *v0; // r7
    signed int v1; // r4
    int result; // r0

    v1 = 0;
    do
    {
        if ( *v0 )
            result = FreeOverworldMapObject();
        ++v0;
        ++v1;
    }
    while ( v1 < 3 );
    return result;
}


// 0x8089d26
char *battle_initBeastSpAIChipQueues()
{
    battleObject_initAIChipQueueSlot_80468C6(4, 1, 0);
    sub_80468EC(0);
    return battleObject_initAIChipQueueSlot_80468C6(3, 0, 1);
}


// 0x8089d44
char *battle_initAIChipQueueSlot3()
{
    sub_80468EC(0);
    return battleObject_initAIChipQueueSlot_80468C6(3, 0, 0);
}


