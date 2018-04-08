# Restful

This is the restful server for controlling tri-server.

# Dependencies

```
pip install falcon
pip install gunicorn
```

# Run

```
gunicorn -w 3 --reload --bind 0.0.0.0 rest_server.app
```

# Supported Operations

## Umount external disk

Umount a specific disk by label.

- **URL**

    /umount/<laebl>

- **Method**

    `PUT`

- **URL params**

    **Required:**

    `label=[lphanumeric]`

- **Success Response**

    **Code:** 200

    **Content:** `{ status: "OK" }`

- **Error Response**

    **Code:** 404 NOT FOUND

    **Content:** `{ error: "No such file or directory" }`

- **Error Response**

    **Code:** 500

    **Content:** `{ error: "<error msg>" }`


