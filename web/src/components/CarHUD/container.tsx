import { useNuiEvent } from "@utilities/utils";
import { useState } from "react";

import { ProgressBar } from 'primereact/progressbar';
import { Knob } from 'primereact/knob';

const CarHud: React.FC = () => {
    const [visible, setVisible] = useState<boolean>(false); // change to true to see the UI.

    // useNuiEvent from @utilities/utils.ts to await NUI Messages easily.
    useNuiEvent('showCarHud', (data: any) => {
        setVisible(true);
    });

    useNuiEvent('hideHCarUD', (data: any) => {
        setVisible(false);
    });

    useNuiEvent('unloadClientHUD', (data: any) => {
        setVisible(false);
    });



    if (!visible) return; // used to hide the hud when hidden
    return (
        <div className="container" id="container">
            <audio
                rel="preload"
                preload="auto"
                id="sounds-seatbelt"
                style={{
                    display: 'none'
                }}
            >
                <source src="sonds/seatbelt.ogg" type="audio/ogg" />
                Your browser doesu not support the audio element.
            </audio>
            <audio
                rel="preload"
                preload="auto"
                id="sounds-seatbelt-off"
                style={{
                    display: 'none'
                }}
            >
                <source src="sounds/seatbeltoff.ogg" type="audio/ogg" />
                Your browser does not support the audio element.
            </audio>
            <div className='gasBar'>
                <ProgressBar ></ProgressBar>
            </div>
        </div>
    )
}

export default CarHud;