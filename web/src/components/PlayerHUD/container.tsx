import { fetchNui, useNuiEvent } from "@utilities/utils";
import { useState } from "react";
import LungsDisplay from "./lungs";
import ClientInfo from "./clientInfo";

interface PlayerJobData {
    jobname: string;
    jobrank: string;
}

interface AOPData {
    enabled: boolean | false;
    current: string | 'State Wide';
}

interface PostalData {
    code: string | number;
    distance: string | number;
}

interface LocationData {
    direction: string;
    street: string;
}

interface PriorityData {
    enabled: boolean | false;
    current: string | 'InActive';
}

const PlayerHud: React.FC = () => {
    const [visible, setVisible] = useState<boolean>(false); // change to true to see the UI.

    // const [ServerName, setServerName] = useState<string>("")
    // const [MaxPlayers, setMaxPlayers] = useState<number>(15)
    // const [StartingMoney, setStartingMoney] = useState<number>(1000)
    // const [isPvpEnabled, setIsPvpEnabled] = useState<string>('False')
    const [logoUrl, setLogoURL] = useState<string>('');
    const [playerJob, setPlayerJob] = useState<PlayerJobData>();
    const [playerCash, setCash] = useState<string | number | undefined>(0);
    const [playerBank, setBank] = useState<string | number | undefined>(0);

    // Server Data
    const [aop, setAop] = useState<AOPData>({ current: 'State Wide', enabled: true });

    const [players, setPlayers] = useState<string | number>(0);
    const [maxPlayers, setMaxPlayers] = useState<number>(32);
    const [postal, setPostal] = useState<PostalData>();
    const [location, setLocation] = useState<LocationData>();

    // const [priority, setPriority] = useState<>();

    const [micActive, setMicActive] = useState<boolean>(false);
    
    const [playerId, setPlayerId] = useState<number | string>('0');
    const [priority, setPriority] = useState<PriorityData>();

    // useNuiEvent from @utilities/utils.ts to await NUI Messages easily.
    useNuiEvent('showHUD', (data: any) => {
        setVisible(true);
    });

    useNuiEvent('hideHUD', (data: any) => {
        setVisible(false);
    });

    useNuiEvent('unloadClientHUD', (data: any) => {
        setVisible(false);
    });

    useNuiEvent('updatePlayers', (data: any) => {
        setPlayers(data?.activePlayers);
    });

    useNuiEvent('updatePostal', (data: any) => {
        let _postal = { 
            code: data?.postalCode ?? postal?.code ?? '', 
            distance: data?.postalrange ? Math.round(data?.postalrange) : Math.round(Number(postal?.distance)),
        };

        setPostal(_postal as PostalData);
    });

    useNuiEvent('updateAOP', (data: any) => {
        let _aop = { ...aop };
        _aop['current'] = data?.aop;
        _aop['enabled'] = data?.enabled;

        setAop(_aop);
    });

    useNuiEvent('startPriority', (data: any) => {
        let _priority = { ...priority };
        _priority['current'] = 'In Progress';
        setPriority(_priority as PriorityData);
    });

    useNuiEvent('endPriority', (data: any) => {
        let _priority = { ...priority };
        _priority['current'] = 'InActive';
        setPriority(_priority as PriorityData);
    });

    useNuiEvent('setPriorityCD', (data: any) => {
        let _priority = { ...priority };
        _priority['current'] = 'Cooldown';
        setPriority(_priority as PriorityData);
    });

    useNuiEvent('loadClientHUD', (data: any) => {
        let _aop = { ...aop };
        _aop['current'] = data?.aop;
        _aop['enabled'] = data?.enabled;

        let _location = { ...location };
        _location['direction'] = data?.heading ?? 'Unknown';
        _location['street'] = data?.street ?? 'Unknown';

        let _job = { ...playerJob };
        _job['jobname'] = data?.jobname;
        _job['jobrank'] = data?.jobgrade;

        let _priority = { ...priority };
        _priority['current'] = 'InActive';
        _priority['enabled'] = data?.usePriority;

        setLogoURL(data?.logo);
        setPriority(_priority as PriorityData);
        setPlayerJob(_job as PlayerJobData);
        setMicActive(data?.micActive);
        setLocation(_location as LocationData);
        setCash(data?.cash);
        setBank(data?.bank);
        setMaxPlayers(data?.maxPlayers);
        setPlayers(data?.activePlayers);
        setPlayerId(data?.playerServerId);
        setAop(_aop);
    });

    if (!visible) return; // used to hide the hud when hidden
    return (
        <div className="container" id="container">
            <LungsDisplay />
            <div className="player-overlay" id="poverlay">
                <div className="overlap">
                    <div className="SERVER-INFO">
                        <div className="PLAYER-ID">
                            ID: <span id="playerId">{playerId}</span>
                        </div>
                        <div className="MIC-wrapper">
                            <i className="fa-solid fa-microphone MIC" id="MIC" style={{ 
                                color: micActive ? '#db15bc' : '#04ffed',
                            }}></i>
                        </div>
                        <div className="online-players">
                            <p className="element-2">
                                <span className="text-wrapper"><i className="fa-solid fa-user"></i> <span id="online">{players}</span></span>
                                <span className="span">/</span>
                                <span className="text-wrapper-3" id="max-players">{maxPlayers}</span>
                            </p>
                        </div>
                    </div>
                    <div className="PLAYER-INFO">
                        <div className="CASH-BAL">
                            <div className="text-wrapper-6"><i className="icon fas fa-wallet"></i> <span id="cash">{playerCash}</span></div>
                        </div>
                        <div className="BANK-BAL">
                            <div className="text-wrapper-6"><i className="icon fas fa-money-check-alt"></i> <span id="bank">{playerBank}</span></div>
                        </div>
                        <div className="PLAYER-JOB">
                            <p className="p">
                                <span className="text-wrapper"><i className="fa-solid fa-business-time"></i> JOB: </span>
                                <span className="text-wrapper-3" id="jobname">{playerJob?.jobname}</span>
                            </p>
                        </div>
                        <div className="JOB-RANK">
                            <p className="p">
                                <span className="text-wrapper"><i className="fa-solid fa-business-time"></i> RANK: </span>
                                <span className="text-wrapper-3" id="jobrank">{playerJob?.jobrank}</span>
                            </p>
                        </div>
                    </div>
                    <img className="SERVER-BRANDING" id="LOGO"
                        src={logoUrl} />
                </div>
                <ClientInfo data={{ AOP: { Current: aop?.current, Enabled: aop?.enabled }, POSTAL: { code: postal?.code!, distance: postal?.distance! }, LOCATION: { direction: location?.direction!, street: location?.street! }, PRIORITY: { enabled: priority?.enabled!, status: priority?.current! } }} />
            </div>
        </div>
    )
}

export default PlayerHud;
