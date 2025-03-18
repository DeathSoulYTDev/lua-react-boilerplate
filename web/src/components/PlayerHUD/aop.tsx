type aop = {
    current: string;
}
export default function AopDisplay({ aop }: { aop: aop }) {
    return (
        <span className="text-wrapper">
            <i className="icon fas fa-map-marked"></i> AOP:
            <span className="text-wrapper-3"
                id="aop"> {aop?.current}
            </span>
        </span>
    )
}