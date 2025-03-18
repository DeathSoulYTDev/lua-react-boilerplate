import AopDisplay from "./aop";
import LocationDisplay from "./location";
import PostalDisplay from "./postal";
import PriorityDisplay from "./priority";

type data = {
    AOP: {
        Enabled: boolean;
        Current: string;
    },
    POSTAL: {
        code: string | number;
        distance: string | number;
    },
    LOCATION: {
        direction: string;
        street: string;
    },
    PRIORITY: {
        status: string;
        enabled: boolean;
    }
    // PRIORITY_STATUS: string;
    // CURRENT_AOP: string;
    // NEAREST_POSTAL_DISTANCE: string;
    // NEAREST_POSTAL: string;
    // PLAYER_LOCATION_DIRECTION: string;
    // PLAYER_LOCATION_STREET: string;
}

export default function ClientInfo({ data }: { data: data }) {
    return (
        <div className="client-info" id="overlay">
            <div className="PA-DISPLAY">
                <p className="priority-status">
                    {data?.PRIORITY?.enabled ? 
                        <PriorityDisplay priority={{ status: data?.PRIORITY?.status }} /> :
                        null
                    }
                    {data?.PRIORITY?.enabled && data?.AOP?.Enabled ?
                        <span className="text-wrapper-3">&nbsp;|&nbsp;</span> :
                        null
                    }
                    {data?.AOP.Enabled ?
                        <AopDisplay aop={{ current: data?.AOP?.Current }} /> :
                        null
                    }
                </p>
            </div>
            <div className="location-display">
                <PostalDisplay postal={{ code: data?.POSTAL?.code, distance: data?.POSTAL?.distance }} />
                <LocationDisplay location={{ direction: data?.LOCATION?.direction, street: data?.LOCATION?.street }} />
            </div>
        </div>
    )
}