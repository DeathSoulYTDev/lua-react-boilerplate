type data = {
    name: string | 'unknown',
    grade: string | 'unknown',
}

export default function JobDisplay({ data }: { data: data }) {
    return (
        <>
            <div className="PLAYER-JOB">
                <p className="p">
                    <span className="text-wrapper"><i className="fa-solid fa-business-time"></i> JOB: </span>
                    <span className="text-wrapper-3" id="jobname">{data?.name}</span>
                </p>
            </div>
            <div className="JOB-RANK">
                <p className="p">
                    <span className="text-wrapper"><i className="fa-solid fa-business-time"></i> RANK: </span>
                    <span className="text-wrapper-3" id="jobrank">{data?.grade}</span>
                </p>
            </div>
        </>
    )
}