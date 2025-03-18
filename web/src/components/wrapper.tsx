import { SocketProvider, useSocket } from '@/context/SocketProvider';
import { PrimeReactProvider } from 'primereact/api';
import PlayerHud from './PlayerHUD/container';
// import CarHud from './CarHUD/container';

import { DndProvider } from 'react-dnd';
import { HTML5Backend } from 'react-dnd-html5-backend';

export default function HUDWrapper() {
    return (
        <SocketProvider>
            <PrimeReactProvider value={{ ripple: true }}>
                <PlayerHud />
                {/* <DndProvider backend={HTML5Backend}>
                    <CarHud />
                </DndProvider> */}
            </PrimeReactProvider>
        </SocketProvider>
    )
}