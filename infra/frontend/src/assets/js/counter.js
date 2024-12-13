// Visitor Counter Tracking
const visitorApiEndpoint = 'https://ygo6a7xq9g.execute-api.us-east-1.amazonaws.com/crc-prod/count/'; 

async function fetchVisitorCount() {
    try {
      const response = await fetch(visitorApiEndpoint);
  
      if (!response.ok) {
        throw new Error(`HTTP error! Status: ${response.status}`);
      }
  
      const data = await response.json();
      return data.count;
    } catch (error) {
      console.error('Error fetching visitor count:', error);
      return 0;
    }
  }

  (async () => {
    try {
      const visitorCount = await fetchVisitorCount();
      console.log(`Current visitor count: ${visitorCount}`);
      
     // Update the DOM element with the visitor count
    const counterElement = document.getElementById('counter');
    counterElement.innerText = visitorCount;
    
    } catch (error) {
      console.error('Error fetching visitor count:', error);
    }
  })();