type priority = {
    status: string;
}

export default function PriorityDisplay({ priority }: { priority: priority }) {
    return (
        <span className="text-wrapper">
            <i className="icon fas fa-exclamation-circle"></i> Priority:
            <span className="priority-status-display" id="pstatus">
                {priority?.status}
            </span>
        </span>
    )
}