type postal = {
    distance: string | number;
    code: string | number;
}

export default function PostalDisplay({ postal }: { postal: postal }) {
    return (
        <div className="POSTAL">
            <p className="n-postal-display">
                <span className="text-wrapper" id="postLoc">&nbsp;<i
                    className="icon fas fa-map-marker-alt"></i>&nbsp;Postal:&nbsp;</span>
                <span className="postal-info" id="postalLoc"><span id="postal">{postal.code}</span>&nbsp;(<span
                    id="postalDist">{postal.distance}m</span>)</span>
            </p>
        </div>
    )
}