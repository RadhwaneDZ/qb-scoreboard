QBScoreboard = {};

$(document).ready(function () {
  window.addEventListener("message", function (event) {
    switch (event.data.action) {
      case "open":
        QBScoreboard.Open(event.data);
        break;
      case "close":
        QBScoreboard.Close();
        break;
    }
  });
});

QBScoreboard.Open = function (data) {
  $(".scoreboard-block").fadeIn(150);
  $("#total-players").html(
    "<p>" + data.players + " of " + data.maxPlayers + "</p>"
  );
  $("#total-police").html(
    "<p>" + data.currentCops + "</p>"
  );
  $("#total-army").html(
    "<p>" + data.currentArmys + "</p>"
  );
  $("#total-ambulance").html(
    "<p>" + data.currentAmbulance + "</p>"
  );

  $.each(data.requiredCops, function (i, category) {
    var beam = $(".scoreboard-info").find('[data-type="' + i + '"]');
    var status = $(beam).find(".info-beam-status");

    if (category.busy) {
      $(status).html('<i class="fas fa-clock"></i>');
    } else if (data.currentCops >= category.minimum) {
      $(status).html('<i class="fas fa-check"></i>');
    } else {
      $(status).html('<i class="fas fa-times"></i>');
    }
  });
  
  $.each(data.requiredArmys, function (i, category) {
    var beam2 = $(".scoreboard-info").find('[data-type="' + i + '"]');
    var status = $(beam2).find(".info-beam2-status");

    if (category.busy) {
      $(status).html('<i class="fas fa-stopwatch"></i>');
    } else if (data.currentArmys >= category.minimum) {
      $(status).html('<i class="fas fa-check-circle"></i>');
    } else {
      $(status).html('<i class="fas fa-ban"></i>');
    }
  });
};

QBScoreboard.Close = function () {
  $(".scoreboard-block").fadeOut(150);
};
