import React, { useState, useEffect } from "react";
import { debugData, fetchNui, useNuiEvent } from "../utils/utils";
debugData([{ action: "setVisible", data: true }]);

const App: React.FC = () => {
	const [servername, setServerName] = useState<string>("Test Server");
	const [startingMoney, setStartingMoney] = useState<number>(1000);
	const [pvp, setPvp] = useState<string>("disabled");

	useEffect(() => {
		fetchNui("getServerInfo").then((data: any) => {
			setServerName(data.serverName);
			setStartingMoney(data.StartingMoney);
			setPvp(data.EnablePvP);
		});
	}, []);

	return (
		<>
			<div className="absolute left-[26%] top-[23%] w-[52%] h-[52%] bg-gray-500 border-[2px] border-black">
				{/* Default Title */}
				<h1 className="select-none absolute top-2 left-[27.1%] text-3xl font-bold">
					React x Lua Boileplate for FiveM
				</h1>
				<h2 className="select-none absolute top-10 left-[37.1%] text-xl">
					Created by CodesAndGames
				</h2>

				<div className="absolute top-20 left-[35%] text-xl text-left">
					<p>Welcome to {servername}</p>
					<p>Your Starting money is ${startingMoney}</p>
					<p>PVP is currently {pvp}</p>
				</div>

				{/* Close UI Button */}
				<button
					className="select-none absolute bottom-2 left-[43.99%] bg-blue-500 text-white px-10 p-2 rounded-md"
					onClick={() => fetchNui("hideFrame")}
				>
					Close
				</button>
			</div>
		</>
	);
};

export default App;
