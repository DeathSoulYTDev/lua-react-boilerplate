type location = {
    direction: string;
    street: string;
}

export default function LocationDisplay({ location }: { location: location }) {
    return (
        <div className="LOCATIONS">
            <p className="n-location-display">
                <span className="text-wrapper" id="directionLoc">
                    <i className="icon fas fa-road"></i>
                    {location?.direction}
                    &nbsp;|&nbsp;
                </span>
                <span className="text-wrapper-3" id="streetLoc">{location?.street} &nbsp;</span>
            </p>
        </div>
    )
}