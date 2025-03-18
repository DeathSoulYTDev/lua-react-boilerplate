type data = {
    cash: string | number;
    bank: string | number;
}

export default function MoneyDisplay({ data }: { data: data }) {
    return (
        <>
            <div className="CASH-BAL">
                <div className="text-wrapper-6"><i className="icon fas fa-wallet"></i> <span id="cash">{data?.cash}</span></div>
            </div>
            <div className="BANK-BAL">
                <div className="text-wrapper-6"><i className="icon fas fa-money-check-alt"></i> <span id="bank">{data?.bank}</span></div>
            </div>
        </>
    )
}