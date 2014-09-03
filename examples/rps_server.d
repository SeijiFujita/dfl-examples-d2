// Written by Christopher E. Miller
// This code is public domain.

// This does not use any DFL code, just the client does.
// To complie:
// 	dmd rps_server ws2_32.lib

import std.stdio;
import std.socket;
import std.conv;


// args[1] = optional listen port
int main(string[] args)
{
	ushort port = 8383;
	Socket[2] clients;
	char[1][2] clientData;
	Socket server;
	
	if(args.length > 1)
		port = std.conv.to!ushort(args[1]);
	
	server = new TcpSocket;
	server.bind(new InternetAddress(port));
	server.listen(1); // Only allow 1 pending connection request.
	
	printf("Server up and running on port %d.\n", cast(int)port);
	
	get_clients:
	for(;;)
	{
		printf("Waiting for clients...\n");
		
		// Wait for clients.
		clients[0] = server.accept();
		writeln("[", clients[0].remoteAddress().toString(), "] Got client 1, waiting for client 2...");
		clients[1] = server.accept();
		writeln("[", clients[1].remoteAddress().toString(), "] Got client 2, starting game...");
		
		for(;;)
		{
			// Tell players to go.
			clients[0].send("g");
			clients[1].send("g");
			
			// Receive player moves.
			if(clients[0].receive(clientData[0]) <= 0)
			{
				// Problem with player 0's connection.
				clients[0].close();
				
				// Tell player 1 "game over, you win."
				clients[1].send("d"); // Die.
				clients[1].close();
				
				continue get_clients; // Go back and wait for new clients.
			}
			
			if(clients[1].receive(clientData[1]) <= 0)
			{
				// Problem with player 1's connection.
				clients[1].close();
				
				// Tell player 0 "game over, you win."
				clients[0].send("d"); // Die.
				clients[0].close();
				
				continue get_clients; // Go back and wait for new clients.
			}
			
			printf("Client 1 = %c, client 2 = %c.\n", clientData[0][0], clientData[1][0]);
			
			// See who won.
			switch(clientData[0][0])
			{
				case 'r':
					switch(clientData[1][0])
					{
						case 'r':
							// Tie.
							clients[0].send("t");
							clients[1].send("t");
							break;
						
						case 'p':
							// Paper beats rock.
							clients[0].send("l");
							clients[1].send("w");
							break;
						
						case 's':
							// Rock beats scissors.
							clients[0].send("w");
							clients[1].send("l");
							break;
						
						default: ;
					}
					break;
				
				case 'p':
					switch(clientData[1][0])
					{
						case 'r':
							// Paper beats rock.
							clients[0].send("w");
							clients[1].send("l");
							break;
						
						case 'p':
							// Tie.
							clients[0].send("t");
							clients[1].send("t");
							break;
						
						case 's':
							// Scissors beat paper
							clients[0].send("l");
							clients[1].send("w");
							break;
						
						default: ;
					}
					break;
				
				case 's':
					switch(clientData[1][0])
					{
						case 'r':
							// Rock beats scissors.
							clients[0].send("l");
							clients[1].send("w");
							break;
						
						case 'p':
							// Scissors beat paper.
							clients[0].send("w");
							clients[1].send("l");
							break;
						
						case 's':
							// Tie.
							clients[0].send("t");
							clients[1].send("t");
							break;
						
						default: 
							break;
					}
					break;
				
				default: 
					break;
			}
			
			// Play another game.
		}
	}
	
	return 0;
}

