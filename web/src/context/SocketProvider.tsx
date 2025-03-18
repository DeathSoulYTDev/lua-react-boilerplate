import React, { createContext, useContext, useEffect, useState, ReactNode } from "react";
import { io, Socket } from "socket.io-client";

// Define the socket type
type SocketType = Socket | null;

// Create a context with a default value of null
const SocketContext = createContext<SocketType>(null);

// Create a custom hook to use the SocketContext
export const useSocket = (): SocketType => {
  return useContext(SocketContext);
};

// Define the props type for the provider
interface SocketProviderProps {
  children: ReactNode; // ReactNode allows any valid React child components
}

export const SocketProvider: React.FC<SocketProviderProps> = ({ children }) => {
  const [socket, setSocket] = useState<SocketType>(null);

  useEffect(() => {
    // Initialize the socket connection
    const newSocket = io(import.meta.env.APP_ENV === 'development' ? import.meta.env.HOST_DOMAIN?.replace("{PORT}", import.meta.env.PORT!) : import.meta.env.PUBLIC_DOMAIN!, {
      withCredentials: true, // Adjust as needed for your server's CORS setup
    });

    newSocket.on("connect", () => {
      console.log("Connected to the server with ID:", newSocket.id);
    });

    setSocket(newSocket);

    // Cleanup the socket connection when the component unmounts
    return () => {
      newSocket.disconnect();
    };
  }, []);

  return (
    <SocketContext.Provider value={socket}>
      {children}
    </SocketContext.Provider>
  );
};
