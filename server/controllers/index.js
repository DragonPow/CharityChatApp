export const successResponse = (res, object) => {
    return res.status(200).json(object);
}

export const failResponse = (res, error) => {
    return res.status(500).json(error);
}

export const inputFailResponse = (res, error) => {
    return res.status(400).json(error);
}

export const notFoundResponse = (res, message) => {
    return res.status(404).json(message);
}

export const unAuthorizedResponse = (res) => {
    return res.status(401).json({error: "Do not permission to access"});
}