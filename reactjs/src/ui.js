// nui.js - Utility functions for FiveM NUI interactions

/**
 * Listens for NUI events from the client.
 * @param {string} eventName - The name of the NUI event.
 * @param {Function} callback - Function to execute when the event is received.
 */
export function useNuiEvent(eventName, callback) {
	window.addEventListener("message", (event) => {
		if (event.data.action === eventName) {
			callback(event.data);
		}
	});
}

export const fetchNui = (action, data = {}) => {
	return new Promise((resolve, reject) => {
		fetch(`https://${GetParentResourceName()}/${action}`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify(data),
		})
			.then((response) => response.json().catch(() => null))
			.then((data) => resolve(data))
			.catch((error) => reject(error));
	});
};
